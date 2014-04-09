require 'spec_helper'

describe Onelinejson::AppControllerMethods do
  describe '.trim_values' do
    let(:trimmed) { Onelinejson::AppControllerMethods.trim_values(hash) }
    context 'when all good' do
      let(:hash) { {a: 1, b: 2} }
      it 'returns eq hash' do
        expect(trimmed).to eq(hash)
      end
    end

    context 'when entry too long' do
      let(:hash) { {a: "aa"*Onelinejson::ENTRY_MAX_LENGTH} }
      it 'trims entry' do
        expect(trimmed[:a]).to have(Onelinejson::ENTRY_MAX_LENGTH).chars
      end
    end
  end

  describe '.extract_headers' do
    let(:headers) { {"HTTP_X" => 0, "HTTP_AUTHORIZATION" => 1} }
    let(:extracted) { Onelinejson::AppControllerMethods.extract_headers(headers) }
    it "rejects Authorization" do
      expect(extracted).to eq({"HTTP_X" => 0})
    end

    context 'when rails 3' do
      let(:headers) { stub(env: {"HTTP_X" => 0}) }
      it 'extracts' do
        expect(extracted).to eq({"HTTP_X" => 0})
      end
    end

    context 'when rails 4' do
      let(:headers) { stub(to_hash: {"HTTP_X" => 0}) }
      it 'extracts' do
        expect(extracted).to eq({"HTTP_X" => 0})
      end
    end
  end

  describe '.extract_params' do
    let(:params) { {password: 0, "password" => 1, "password_confirmation" => 2, "x" => 3} }
    let(:extracted) { Onelinejson::AppControllerMethods.extract_params(params) }

    it 'rejects password' do
      expect(extracted).to eq({"x" => 3})
    end

    it 'rejects password_confirmation' do
      expect(extracted).to eq({"x" => 3})
    end
  end

  describe '.extract_params' do
    it 'returns sanetized params'
    it 'rejects controller'
    it 'rejects action'
    context 'when value is a file' do
      it 'rejects whenfiles'
    end
    context 'when value is a hash' do
      it 'rejects'
    end
  end
end

describe Onelinejson do
  describe Onelinejson::BEFORE_HOOK do
    it 'works'
  end

  describe '.enforce_max_json_length' do
    let(:enforced) { Onelinejson.enforce_max_json_length(hash) }
    context 'when all good' do
      let(:hash)  { {a: 1, b: 2} }
      it 'returns hash' do
        expect(enforced).to be(hash)
      end
    end

    context 'when hash too long' do
      context 'when removing params fixes it' do
        let(:hash) { {a: 1, request: {
          headers: 'a', params: 'b'*Onelinejson::LOG_MAX_LENGTH
        }} }
        it 'returns hash without params' do
          expect(enforced[:request].keys).to eq([:headers])
        end
      end

      context 'when removing params and headers fixes it' do
        let(:hash) { {a: 1, request: {
          headers: 'a'*Onelinejson::LOG_MAX_LENGTH, params: 'b'*Onelinejson::LOG_MAX_LENGTH
        }} }
        it 'returns hash without params and headers' do
          expect(enforced[:request].keys).to be_empty
        end
      end
    end
  end
end

