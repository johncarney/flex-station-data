require "flex_station_data/linear_regression"

RSpec.describe FlexStationData::LinearRegression do
  let(:linear_regression) { described_class.new(x, y) }

  let(:x) { instance_double(Array, :x) }
  let(:y) { instance_double(Array, :y) }

  let(:slope)     { instance_double(Float, :slope) }
  let(:intercept) { instance_double(Float, :intercept) }
  let(:r_squared) { instance_double(Float, :r_squared) }
  let(:line_fit)  { instance_double(LineFit, :line_fit, coefficients: [ slope, intercept ], rSquared: r_squared) }

  describe "#slope" do
    it "returns the slope of the regression", :aggregate_failures do
      allow(LineFit).to receive(:new).and_return line_fit
      expect(line_fit).to receive(:setData).with(x, y)
      expect(linear_regression.slope).to be slope
    end

    context "given non-numeric values in y" do
      let(:x) { [   1,   2,   3 ] }
      let(:y) { [ "A", "B", "C" ] }

      it "returns nil" do
        expect(linear_regression.slope).to be_nil
      end
    end
  end

  describe "#intercept" do
    it "returns the intercept of the regression", :aggregate_failures do
      allow(LineFit).to receive(:new).and_return line_fit
      expect(line_fit).to receive(:setData).with(x, y)
      expect(linear_regression.intercept).to be intercept
    end

    context "given non-numeric values in y" do
      let(:x) { [   1,   2,   3 ] }
      let(:y) { [ "A", "B", "C" ] }

      it "returns nil" do
        expect(linear_regression.intercept).to be_nil
      end
    end
  end

  describe "#r_squared" do
    it "returns the r_squared of the regression", :aggregate_failures do
      allow(LineFit).to receive(:new).and_return line_fit
      expect(line_fit).to receive(:setData).with(x, y)
      expect(linear_regression.r_squared).to be r_squared
    end

    context "given non-numeric values in y" do
      let(:x) { [   1,   2,   3 ] }
      let(:y) { [ "A", "B", "C" ] }

      it "returns nil" do
        expect(linear_regression.r_squared).to be_nil
      end
    end
  end
end
