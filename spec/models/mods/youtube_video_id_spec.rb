# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mod, type: :model do
  let(:mod) { create(:mod, video: video) }


  describe '#youtube_video_id' do
    context 'with a youtube link' do
      let(:video) { 'https://www.youtube.com/watch?v=cHlAvVjfN10' }
      it 'works' do
        expect(mod.youtube_video_id).to eq 'cHlAvVjfN10'
      end
    end

    context 'with a random invalid link' do
      # let(:video) { 'lien de la vidéo' }
      it 'works' do
        expect(Mod.create(video: 'lien de la vidéo')).not_to be_valid
      end
    end

    context 'with a blank link' do
      let(:video) { '' }
      it 'works' do
        expect(mod.youtube_video_id).to eq nil
      end
    end

    context 'with a nil link' do
      let(:video) { nil }
      it 'works' do
        expect(mod.youtube_video_id).to eq nil
      end
    end
  end
end
