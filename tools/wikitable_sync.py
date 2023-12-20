#! /usr/bin/python3
#
# wikitable.py --
# read a markdowntable table from the wiki and parse it into a nice datastructure.
# 
# Extended version to also capture h1, h2, h3, h4, h5 headings
# (C) 2023 juergen@fabmail.org

import requests
import sys
# -----------------------------------------------------------------------------
# Name:        html_table_parser
# Purpose:     Simple class for parsing an (x)html string to extract tables.
#              Written in python3
#
# Author:      Josua Schmid
#
# Created:     05.03.2014
# Copyright:   (c) Josua Schmid 2014
# Licence:     AGPLv3
# -----------------------------------------------------------------------------

from html.parser import HTMLParser


class HTMLTableParser(HTMLParser):
    """ This class serves as a html table parser. It is able to parse multiple
    tables which you feed in. You can access the result per .tables field.
    """
    def __init__(
        self,
        decode_html_entities=False,
        data_separator=' ',
    ):

        HTMLParser.__init__(self)

        self._parse_html_entities = decode_html_entities
        self._data_separator = data_separator

        self._in_td = False
        self._in_th = False
        self._in_heading = 0    # 1, 2, 3, 4, 5
        self._current_heading = []
        self._current_headings = []
        self._current_table = []
        self._current_row = []
        self._current_cell = []
        self.tables = []

    def handle_starttag(self, tag, attrs):
        """ We need to remember the opening point for the content of interest.
        The other tags (<table>, <tr>) are only handled at the closing point.
        """
        if tag == 'td':
            self._in_td = True
        if tag == 'th':
            self._in_th = True
        if tag in ['h1', 'h2', 'h3', 'h4', 'h5']:
            self._in_heading = int(tag[1])

    def handle_data(self, data):
        """ This is where we save content to a cell """
        if self._in_td or self._in_th:
            self._current_cell.append(data.strip())
        if self._in_heading > 0:
            self._current_heading.append(data.strip())

    def handle_charref(self, name):
        """ Handle HTML encoded characters """

        if self._parse_html_entities:
            self.handle_data(self.unescape('&#{};'.format(name)))

    def handle_endtag(self, tag):
        """ Here we exit the tags. If the closing tag is </tr>, we know that we
        can save our currently parsed cells to the current table as a row and
        prepare for a new row. If the closing tag is </table>, we save the
        current table and prepare for a new one.
        """
        if tag == 'td':
            self._in_td = False
        elif tag == 'th':
            self._in_th = False

        if tag in ['td', 'th']:
            final_cell = self._data_separator.join(self._current_cell).strip()
            self._current_row.append(final_cell)
            self._current_cell = []
        elif tag == 'tr':
            self._current_table.append(self._current_row)
            self._current_row = []
        elif tag == 'table':
            self.tables.append({ 'rows': self._current_table, 'headings': self._current_headings})
            self._current_table = []
            self._current_headings = []
        elif tag in ['h1', 'h2', 'h3', 'h4', 'h5']:
            self._current_headings.append(["h"+str(self._in_heading), ' '.join(self._current_heading)])
            self._in_heading = 0        # without checking for nested headings ...
            self._current_heading = []
            

if __name__ == '__main__':
  defaultlink = "https://wiki.fablab-nuernberg.de/w/ZING_4030"
  defaultlink = "https://wiki.fablab-nuernberg.de/w/Nova_35"
  if len(sys.argv) > 1:
    link = sys.argv[1]
  else:
    link = defaultlink

  if link[:8].lower() == 'https://' or link[:7].lower() == 'http://':
    f = requests.get(link)
    # body = f.content       # bytes
    body = f.text       # as per HTTP-header
    f.close()
  else:
    f = open(link)
    body = f.read()

  p = HTMLTableParser()
  p.feed(body)
  print(f"Found {len(p.tables)} tables in {link} :")
  for i in range(len(p.tables)):
    print(p.tables[i]['headings'][-1])

  # print(p.tables[2]['headings'][-1], "----------------------\n", p.tables[2]['rows'])
