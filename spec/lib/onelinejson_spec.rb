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
    context 'when rails 3' do
      it 'extracts'
    end

    context 'when rails 4' do
      it 'extracts'
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

