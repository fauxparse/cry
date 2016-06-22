require 'spec_helper'

class Sender
  include Cry

  def succeed
    publish(:success, :arg1, :arg2)
  end

  def celebrate
    publish(:celebration, :arg1, :arg2)
  end

  def fail
    publish(:failure)
  end

  def succeed!
    publish!(:success, :arg1, :arg2)
  end
end

class Receiver
  def success(arg1, arg2); end
  def success2(arg1, arg2); end
  def failure; end
end

describe Cry do
  subject(:sender) { Sender.new }
  let(:receiver) { Receiver.new }

  context 'with no listeners' do
    describe '#publish' do
      it 'does not raise an error' do
        expect { subject.succeed }.not_to raise_error
      end
    end

    describe '#publish!' do
      it 'raises an error' do
        expect { subject.succeed! }
          .to raise_error Cry::NoListenersError, "nothing listening for success"
      end
    end
  end

  context 'with listeners' do
    before do
      subject
        .on(:success) { |a, b| receiver.success(a, b) }
        .on(:failure) { receiver.failure }
    end

    describe '#publish' do
      it 'sends arguments' do
        expect(receiver).to receive(:success).with(:arg1, :arg2)
        sender.succeed
      end

      it 'publishes plain events' do
        expect(receiver).to receive(:failure).with(no_args)
        sender.fail
      end
    end
  end

  context 'with the same listener defined for multiple events' do
    before do
      subject
        .on(:success, :celebration) { |a, b| receiver.success(a, b) }
    end

    describe '#publish' do
      it 'hits the first event' do
        expect(receiver).to receive(:success).with(:arg1, :arg2)
        sender.succeed
      end

      it 'hits the second event' do
        expect(receiver).to receive(:success).with(:arg1, :arg2)
        sender.celebrate
      end
    end
  end

  context 'with multiple listeners defined for the same event' do
    before do
      subject
        .on(:success) { |a, b| receiver.success(a, b) }
        .on(:success) { |a, b| receiver.success2(a, b) }
    end

    describe '#publish' do
      it 'hits both listeners' do
        expect(receiver).to receive(:success).with(:arg1, :arg2)
        expect(receiver).to receive(:success2).with(:arg1, :arg2)
        sender.succeed
      end
    end
  end
end
