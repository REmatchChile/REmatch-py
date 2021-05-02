import sys
import unittest
import pyrematch as re


class Test(unittest.TestCase):

    def setUp(self):
        string = "one two three four five ..."
        pattern = "!x{one} !y{two} !z{three}"
        self.regex_obj = re.compile(pattern)
        self.match_obj = self.regex_obj.find(string)

    #MatchObject tests

    def test_start(self):
        self.assertEqual(self.match_obj.start('x'), 0)
        self.assertEqual(self.match_obj.start('y'), 4)
        self.assertEqual(self.match_obj.start('z'), 8)

    def test_end(self):
        self.assertEqual(self.match_obj.end('x'), 3)
        self.assertEqual(self.match_obj.end('y'), 7)
        self.assertEqual(self.match_obj.end('z'), 13)

    def test_span(self):
        self.assertTupleEqual(self.match_obj.span('x'), (0, 3))
        self.assertTupleEqual(self.match_obj.span('y'), (4, 7))
        self.assertTupleEqual(self.match_obj.span('z'), (8, 13))

    def test_group(self):
        self.assertEqual(self.match_obj.group('x'), 'one')
        self.assertEqual(self.match_obj.group(1), 'one')
        self.assertEqual(self.match_obj.group('y'), 'two')
        self.assertEqual(self.match_obj.group(2), 'two')
        self.assertEqual(self.match_obj.group('z'), 'three')
        self.assertEqual(self.match_obj.group(3), 'three')

    def test_gruops(self): #Agregar el group(0) cuando esté definida la sintaxis
        self.assertTupleEqual(self.match_obj.groups(), ('one', 'two', 'three'))

    def test_groupdict(self):
        self.assertDictEqual(self.match_obj.groupdict(), {'x': 'one', 'y': 'two', 'z': 'three'})


    #RegexObject tests

    def test_find(self):
        regex_obj = re.compile('!x{abyss}')

        match1 = regex_obj.find("abcdefgh")
        self.assertIsNone(match1)

        match = regex_obj.find("Wow, this is abyssal")
        self.assertIsNotNone(match)
        self.assertEqual(match.start('x'), 13)
        self.assertEqual(match.end('x'), 18)
        self.assertTupleEqual(match.span('x'), (13, 18))
        self.assertEqual(match.group('x'), 'abyss')
        self.assertTupleEqual(match.groups(), ('abyss',))
        self.assertDictEqual(match.groupdict(), {'x': 'abyss'})

        match = regex_obj.find("abyssal")
        self.assertIsNotNone(match)
        self.assertEqual(match.start('x'), 0)
        self.assertEqual(match.end('x'), 5)
        self.assertTupleEqual(match.span('x'), (0, 5))
        self.assertEqual(match.group('x'), 'abyss')
        self.assertTupleEqual(match.groups(), ('abyss',))
        self.assertDictEqual(match.groupdict(), {'x': 'abyss'})


    def test_findall(self):
        regex_obj = re.compile('!x{teen}')
        matches = regex_obj.findall('abcdefgh')
        self.assertListEqual(matches, [])
        matches = regex_obj.findall('fifteen, sixteen, seventeen,...')
        matches.sort(key=lambda match: match.start('x'))
        expected = [(3, 7), (12, 16), (23, 27)]
        for pos in range(len(matches)):
            match = matches[pos]
            self.assertIsNotNone(match)
            self.assertEqual(match.start('x'), expected[pos][0])
            self.assertEqual(match.end('x'), expected[pos][1])
            self.assertTupleEqual(match.span('x'), expected[pos])
            self.assertEqual(match.group('x'), 'teen')
            self.assertTupleEqual(match.groups(), ('teen',))
            self.assertDictEqual(match.groupdict(), {'x': 'teen'})

    def test_finditer(self):
        regex_obj = re.compile('!x{teen}')
        matches_iterator = regex_obj.finditer('fifteen, sixteen, seventeen,...')
        matches = set()
        for match in matches_iterator:
            matches.add(match)
        expected = {(3, 7), (12, 16), (23, 27)}
        self.assertEqual(set(map(lambda m: m.span('x'), matches)), expected)
        for match in matches:
            self.assertEqual(match.group('x'), 'teen')
            self.assertTupleEqual(match.groups(), ('teen',))
            self.assertDictEqual(match.groupdict(), {'x': 'teen'})

    def test_search(self):
        regex_obj = re.compile('!x{a...s}')
        match = regex_obj.search("abcdefgh")
        self.assertIsNone(match)
        match = regex_obj.search("abyssal")
        self.assertIsNotNone(match)
        self.assertEqual(match.start('x'), 0)
        self.assertEqual(match.end('x'), 5)
        self.assertTupleEqual(match.span('x'), (0, 5))
        self.assertEqual(match.group('x'), 'abyss')
        self.assertTupleEqual(match.groups(), ('abyss',))
        self.assertDictEqual(match.groupdict(), {'x': 'abyss'})

    def test_match(self):
        regex_obj = re.compile('!x{a...s}')
        match = regex_obj.match('the abyssal')
        self.assertIsNone(match)
        match = regex_obj.match('abyssal')
        self.assertIsNotNone(match)
        self.assertEqual(match.start('x'), 0)
        self.assertEqual(match.end('x'), 5)
        self.assertTupleEqual(match.span('x'), (0, 5))
        self.assertEqual(match.group('x'), 'abyss')
        self.assertTupleEqual(match.groups(), ('abyss',))
        self.assertDictEqual(match.groupdict(), {'x': 'abyss'})


    def test_fullmatch(self):
        regex_obj = re.compile('!x{a...s}')
        match = regex_obj.fullmatch('abyssal')
        self.assertIsNone(match)
        match = regex_obj.fullmatch('abyss')
        self.assertIsNotNone(match)
        self.assertEqual(match.start('x'), 0)
        self.assertEqual(match.end('x'), 5)
        self.assertTupleEqual(match.span('x'), (0, 5))
        self.assertEqual(match.group('x'), 'abyss')
        self.assertTupleEqual(match.groups(), ('abyss',))
        self.assertDictEqual(match.groupdict(), {'x': 'abyss'})

if __name__ == '__main__':
    unittest.main()