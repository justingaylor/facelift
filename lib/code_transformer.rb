require 'ripper'
require 'sorcerer'

class CodeTransformer
  IDIOM_LIBRARY = [
    {
      pattern: Ripper.sexp_raw("VAL1 + VAL2"),
      transformation: Ripper.sexp_raw("VAL2 + VAL1")
    }
  ]

  def self.transform(code)
    tree = Ripper.sexp_raw(code)
    transformed = nil
    if RuleMatcher.match(tree, IDIOM_LIBRARY.first[:pattern])
      # Return transformed code
      transformed = perform_transform(tree, IDIOM_LIBRARY.first)
    end

    if transformed
      result = Sorcerer.source(transformed, indent: true)
    else
      result = code
    end
    result
  end

  def self.perform_transform(code, rule)
    pattern, transformation = rule.values_at(:pattern, :transformation)
    substitutions = identify_substitutions(code, pattern)
    transform_code(transformation, substitutions)
  end

  def self.identify_substitutions(tree, pattern, substitutions={})
    tree.each_with_index do |obj, i|
      if obj.is_a?(Array)
        identify_substitutions(obj, pattern[i], substitutions)
      elsif pattern[i] == :var_ref
        # subtitutions["VAL1"] = [:vcall, [:@ident, "a", [1, 0]]]
        substitutions[pattern[i+1][1]] = tree
      else
        # Do nothing
      end
    end
    substitutions
  end

  def self.transform_code(transformation, substitutions, types=nil)
    result = transformation.dup
    types ||= substitutions.values.collect(&:first).uniq
    transformation.each_with_index do |obj, i|
      if obj.is_a?(Array)
        if obj[0] == :var_ref && substitutions[obj[1][1]]
          # perform transformation
          result[i] = substitutions[obj[1][1]]
        else
          result[i] = transform_code(transformation[i], substitutions, types)
        end
      else
        # Do nothing
      end
    end
    result
  end
end
