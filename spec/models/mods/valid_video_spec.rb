# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mod, type: :model do
  subject { build(:mod, video: video) }


  describe '#valid_video' do
    context 'with a youtube link' do
      let(:video) { 'https://www.youtube.com/watch?v=cHlAvVjfN10' }
      it 'mod is valid' do
        expect(subject.valid?).to be true
      end
    end

    context 'with a random link' do
      let(:video) { 'lien de la vidéo' }
      it 'mod is NOT valid' do
        expect(subject.valid?).to be false
      end
    end

    context 'with a blank link' do
      let(:video) { '' }
      it 'mod is valid' do
        expect(subject.valid?).to be true
      end
    end

    context 'with a nil link' do
      let(:video) { nil }
      it 'mod is valid' do
        expect(subject.valid?).to be true
      end
    end
  end
end
