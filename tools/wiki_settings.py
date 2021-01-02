#! /usr/bin/python3
#
# wiki_settings.py -- convert settings from and to wiki tables syntax.
#
# Requires: urllib
#
# 2020-12-27, v0.1 jw   - initial draught

import sys, re, urllib.request

class WikiTable:
  """
     read and write operations on a wiki-table
  """
  def __init__(self, url, heading_re=None, skipcoint=0, prefer_raw=True, format=None):
    """
        A WikiTable object can be generated by reading a url. in case of local file
        url, the leading 'file://' part can be omitted, relative paths are supported.
        HTML, mediawiki, and markdown are supported.

        Importing data can select one out of ultiple tables found in the url or file
        resource using heading_re and/or skipcount.
        Normally the first table found is imported. Any leading and trailing texts are ignored.
        If heading_re is not none, then a matching <Hn> or ## or ====== style heading searched.
        Searching for tables then starts after this heading. If there is no match
        import fails, just as if there were no tables in the resource.
        skipcount can be a positive integer. It skips the given number of tables.

        intial import can be suppressed by passing url=None
    """
    if url is None:
      self.url = None
      self.document = ''
    else:
      m = re.match(r'\w+://', url)
      if m and m.group(0).lower() == 'file://': url = url[m.end():]

      m = re.match(r'\w+://', url)
      if m:
        self._import_url(url, prefer_raw)
      else:
        self._import_file(url)

    if format is None:
      self.guess = self.guess_format(self.document)
      self.format = 'wiki' if self.guess['wiki'] > self.guess['html'] else 'html'
    else:
      known = ['html', 'wiki']  # CAUTION: keep in sync with the keys returned by guess_format()
      format = format.lower()
      if format not in known:
        raise(ValueError("Unknown format '%s', expected one of %s" % (format, str(known))))
      self.format = format      # should be one of 'html', 'wiki'
    if self.format == 'wiki':
      self.tables = self.find_tables_wiki(self.document)
    else:
      self.tables = self.find_tables_html(self.document)


  def _import_url(self, urls, prefer_raw):
    if type(urls) == type(""): urls = [ urls ]
    if prefer_raw: urls.insert(0, urls[0] + "?action=raw")
    for url in urls:
      try:
        a = urllib.request.urlopen(url)
        d = a.read()
        if type(b'') == type(d):
          self.document = d.decode('utf-8')
        else:
          self.document = str(d)
        self.url = a.url
      except Exception as e:
        print("Failed to load URL '%s' :" % url, e, file=sys.stderr)
      else:
        break


  def _import_file(self, filename):
    try:
      fd = open(filename)
      d = fd.read()
      if type(b'') == type(d):
        self.document = d.decode('utf-8')
      else:
        self.document = str(d)
      self.url = 'file://'+filename
    except Exception as e:
      print("Failed to load file '%s' :" % url, e, file=sys.stderr)


  def guess_format(self, text):
    """
        count frequency of each letter. if the '<', '>' are high, it is HTML,
        if the '|' === ---' are higher, then it is wiki.
        two tables: total freq, and freq of first char in line.
    """
    freq = {}      # all characters
    freq1 = {}     # first character in line
    first_in_line = True
    for c in str(text):
      if c in " \t\r\n":                        # ignore whitespace
        if c in "\n\r": first_in_line = True
        continue
      if not c in freq:
        freq[c] = 1
      else:
        freq[c] = freq[c] + 1
      if first_in_line:
        if not c in freq1:
          freq1[c] = 1
        else:
          freq1[c] = freq1[c] + 1
      first_in_line = False
    self.freq  = ''.join(map(lambda x: x[0], sorted(freq.items(),  key=lambda x: x[1], reverse=True)))
    self.freq1 = ''.join(map(lambda x: x[0], sorted(freq1.items(), key=lambda x: x[1], reverse=True)))

    # HTML:
    #   freq1:  '<C-EBADPTU1[}SuNRH'
    #   freq:   'etia<>n"rdsl/ocph=-0b.:3,_'...'%PRFTjI&9()[]VU#W!{}H?qOQ+Z\\|`@\'J*„“‐Y–X$\xad'
    # Wiki:
    #   freq1:  '|=*!D{B[SEAF}HVhuI/LN'
    #   freq:   'e|nriatsl0mhuocdg=pf.-21wb5k!7z/'...'\'4FKx[T]"ICWG()yUR*_%HZO`{}&;+q#@>\\<'

    # evaluators
    guess_wiki = 0
    guess_html = 0
    idx_eq   = (self.freq1+'=').index('=')
    idx_lt   = (self.freq1+'<').index('<')
    idx_hash = (self.freq1+'#').index('#')

    if idx_lt < min(idx_hash, idx_eq):
      guess_html += 10
    else:
      if idx_eq < idx_hash:
        guess_wiki += 10
      else:
        guess_wiki += 2

    if '!' in self.freq1: guess_wiki += 1       # used as first char in wiki tables
    if '|' in self.freq1: guess_wiki += 1       # used as first char in wiki tables

    # this should normally override all the small values from freq1.
    # we still do freq1, in case everything is near the center.
    idx_lt = (self.freq+'<').index('<')
    idx_gt = (self.freq+'>').index('>')
    idx_mid = len(self.freq) / 2
    if idx_lt < idx_mid:                        # found '<' in the first half
      guess_html += idx_mid - idx_lt
    else:
      guess_wiki += idx_lt  - idx_mid
    if idx_gt < idx_mid:                       # found '>' in the first half
      guess_html += idx_mid - idx_gt
    else:
      guess_wiki += idx_gt  - idx_mid

    # report what we got
    return { 'wiki': guess_wiki, 'html': guess_html }


  def find_tables_wiki(self, document):
    """
        Walk through mediawiki source code, find tables.
        For each table we record the byte offset, where it starts in document, and the length in bytes in document.
        This makes it easy to search for headings and texts leading up to a table.
        Reference: https://www.mediawiki.org/wiki/Help:Tables#Wiki_table_markup_summary

        {|        table start, required
        |-
        ! Material !! MinPower1 !! MaxPower1 !! Speed !! Fokus !! Bemerkung
        |-
        !          !! [ % ] !! [ % ] !! [&nbsp;mm/s&nbsp;] !! [&nbsp;mm&nbsp;]!!
        |-
        | Acryl 2mm ||  45 || 70 || 45 || ||  jw 20201003 fln
        |-
        |}        table end, required

    """
    l = re.split(r'^({\||\|})', document, flags=re.MULTILINE)
    tables = []
    for i in range(len(l)):
      if l[i] == '{|':
        t = { 'pre': l[i-1], 'body': l[i+1] }

        tables.append(t)

    return tables


  def find_tables_html(self, document):
    raise(ValueError("find_tables_html not impl. format = %s" % (format)))

# ----------------------------------------
if __name__ == "__main__":
  t = WikiTable('http://wiki.fablab-nuernberg.de/w/Nova_35')
  print("%d bytes loaded from %s" % (len(t.document), t.url))
