class RuleMatcher

  def self.traverse(tree)

  end

  def self.match(tree, pattern, in_var_ref=false)
    result = true
    tree.each_with_index do |obj, i|
      if obj.is_a?(Array)
        result = match(obj, pattern[i], in_var_ref)
      elsif pattern[i] != obj
        if pattern[i] == :var_ref
          # :var_ref in the pattern matches anything
          in_var_ref = true
          next
        elsif pattern[i] == :@const && pattern[i+1] =~ /^VAR\d*$/
          break
        else
          result = false
          break
        end
      else
        next
      end
    end
    result
  end
end
