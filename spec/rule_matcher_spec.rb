describe RuleMatcher do
  let (:code) { Ripper.sexp_raw("a + b")[1] }

  let(:pattern) { Ripper.sexp_raw("VAL1 + VAL2")[1] }
  let(:unmatchable) { Ripper.sexp_raw("VAL1 + VAL2") }

  describe ".match" do
    it "correctly matches" do
      expect(RuleMatcher.match(code, pattern)).to eq(true)
    end

    it "correctly doesn't match" do
      expect(RuleMatcher.match(code, unmatchable)).to eq(false)
    end
  end
end
