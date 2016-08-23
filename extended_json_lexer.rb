require 'rouge'
module Rouge
  module Lexers
    class ExtendedJSON < Rouge::Lexers::JSON
      tag 'extended-json'
    end
  end
end