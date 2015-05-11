describe CodeTransformer do
  describe ".transform" do
    it "correctly transforms non-idiomatic Ruby to idiomatic Ruby" do
      {
        "a + b\n" => "b + a\n",
        "x + y\n" => "y + x\n"
      }.each do |(original, transformed)|
        expect(CodeTransformer.transform(original)).to eq(transformed)
      end
    end
  end

  describe ".identify_substitutions" do
    let(:program) { Ripper.sexp_raw "a + b" }
    let(:pattern) { Ripper.sexp_raw "VAR1 + VAR2" }

    it "works" do
      result = CodeTransformer.identify_substitutions(program, pattern)
      expect(result).to be_a(Hash)
      expect(result.keys.size).to eq(2)
      expect(result.keys).to contain_exactly("VAR1", "VAR2")
    end
  end

  describe ".transform_code" do
    let(:transformation) { Ripper.sexp_raw "VAR2 + VAR1" }
    let(:substitutions) do
      {
        "VAR1"=>[:vcall, [:@ident, "a", [1, 0]]],
        "VAR2"=>[:vcall, [:@ident, "b", [1, 4]]]
      }
    end
    let(:expected) do
      [:program,
       [:stmts_add,
        [:stmts_new],
        [:binary, [:vcall, [:@ident, "b", [1, 4]]], :+, [:vcall, [:@ident, "a", [1, 0]]]]]]
    end


    it "works" do
      result = CodeTransformer.transform_code(transformation, substitutions)
      expect(result).to eq(expected)
    end
  end
end
