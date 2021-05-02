#ifdef SWIG

// Rematch interface
%module rematch

%include <std_string.i>
%include <std_pair.i>
%include <std_vector.i>
%include <stdint.i>
%include "std_unique_ptr.i"

%{
#include "regex/regex.hpp"
#include "regex/regex_options.hpp"
#include "match.hpp"
#include "eval.hpp"
#include "anchors.hpp"
using namespace rematch;
using namespace std;
%}

%inline %{
// typedef long unsigned int size_t;
%}

%template(PairSize) std::pair<size_t,size_t>;
%template(StrVector) std::vector<std::string>;

// %apply const std::string& {std::string *text};

wrap_unique_ptr(MatchUniquePtr, Match);

using Span = std::pair<size_t, size_t>;
using Match_ptr = std::unique_ptr<Match>;

enum Anchor {
  kUnanchored = 0,
  kSingleAnchor = 1,
  kBothAnchors = 3
};

class RegExOptions {
 public:
  RegExOptions();
  bool multi_line() const;
  void set_multi_line(bool b);
  bool line_by_line() const;
  void set_line_by_line(bool b);
  bool dot_nl() const;
  void set_dot_nl(bool b);
  bool early_output() const;
  void set_early_output(bool b);
  bool save_anchors() const;
  void set_save_anchors(bool b);
}; // end class RegExOptions

class Match {
 public:
  Match() = default;
  size_t start(std::string varname) const;
  size_t end(std::string varname) const;
  Span span(std::string var) const;
  std::vector<std::string> variables() const;
}; // end class Match

class EvaluatorIter {
 public:
  Match next();
  bool hasNext();

  EvaluatorIter() = default;
}; // end class Evaluator

class RegEx {
 public:
  RegEx(std::string regex, RegExOptions opt = RegExOptions());
  ~RegEx();
  EvaluatorIter findIter(const std::string &text, Anchor anchor);
  std::vector<std::string> varScheme();
}; // end class Regex

#endif // SWIG
