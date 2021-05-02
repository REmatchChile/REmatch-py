import sys
from . import rematch

class Match:

    def __init__(self, match_object, document):
        self.match_object = match_object
        self.document = document
        self.variables = match_object.variables()
        # self.__span = span
        # self.__start = start
        # self.__end = end

    def start(self, capture):
        if str(capture).isnumeric():
            capture = self.variables[capture - 1]
        return self.match_object.start(capture)

    def end(self, capture):
        if str(capture).isnumeric():
            capture = self.variables[capture - 1]
        return self.match_object.end(capture)

    def span(self, capture):
        if str(capture).isnumeric():
            capture = self.variables[capture - 1]
        return self.match_object.span(capture)

    def group(self, capture):
        if str(capture).isnumeric():
            capture = self.variables[capture - 1]
        span = self.match_object.span(capture)
        return self.document[span[0]:span[1]]

    def groups(self):
        matches = []
        for var in self.variables:
            span = self.match_object.span(var)
            matches.append(self.document[span[0]:span[1]])
        return tuple(matches)

    def groupdict(self):
        matches = dict()
        for var in self.variables:
            span = self.match_object.span(var)
            matches[var] = self.document[span[0]:span[1]]
        return matches

class Regex:

    def __init__(self, pattern, **flags): # Flags del estilo: save_anchors=True, early_output=True
        self.pattern = pattern
        self.rgx_opts = self.set_flags(flags) #Probar si se pasan todas las flags o es necesario poner **
        self.RegEx = rematch.RegEx(pattern, self.rgx_opts)

    def set_flags(self, flags):
        rgx_opts = rematch.RegExOptions()
        for key, value in flags.items():
            if key == "save_anchors":
                rgx_opts.set_save_anchors(value)
            elif key == "multi_line":
                rgx_opts.set_multi_line(value)
            elif key == "line_by_line":
                rgx_opts.set_line_by_line(value)
            elif key == "dot_nl":
                rgx_opts.set_dot_nl(value)
            elif key == "early_output":
                rgx_opts.set_early_output(value)
        return rgx_opts

    def find(self, string):
        evaluator = self.RegEx.findIter(string, rematch.kUnanchored)
        if evaluator.hasNext():
            match = evaluator.next()
            return Match(match, string)
        else:
            return None

    def findall(self, string): # Retornar objetos match
        matches = []
        it = self.RegEx.findIter(string, rematch.kUnanchored)
        while it.hasNext():
            matches.append(Match(it.next(), string))
        return matches

    def finditer(self, string):
        it = self.RegEx.findIter(string, rematch.kUnanchored)
        while it.hasNext():
            yield Match(it.next(), string)
        return None
    def search(self, string):
        return self.find(string)

    def match(self, string):
        it = self.RegEx.findIter(string, rematch.kSingleAnchor)
        if it.hasNext():
            m = it.next()
            return Match(m, string)
        else:
            return None

    def fullmatch(self, string):
        it = self.RegEx.findIter(string, rematch.kBothAnchors)
        if it.hasNext():
            m = it.next()
            return Match(m, string)
        else:
            return None

def compile(pattern, **flags):
    return Regex(pattern, **flags)