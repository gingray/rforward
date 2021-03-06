RSpec.describe Rforward do
  before(:all) do
    Config.register Config::FLUENTD do
      mock = double
      allow(mock).to receive(:post)
      mock
    end

  end
  describe DirectoryProcessor do
    context 'invalid path' do
      let(:invalid_path) { 'sadfad+asdfasd' }
      let(:result) { DirectoryProcessor.call invalid_path, '.log' }
      it 'case 1' do
        expect {result }.to raise_error WrongPathEx
      end
    end

    context 'valid path', :focus do
      let(:valid_path) { fixture_path }
      let(:result) { DirectoryProcessor.call valid_path, '.log' }
      it 'case 1' do
        expect(result).to be_a(Array)
      end
    end
  end
  describe FileProcessor do
    context 'tag from filename' do
      let(:filepath) { '/home/app/logs/fluentd_app.log.20171215_0_json.log' }
      let(:processor) {FileProcessor.new filepath, nil }
    end
  end
end
