require 'rails_helper'

describe Plan do
  describe 'バリデーションチェック' do
    let(:provider) { create(:provider) }

    describe '正常系' do
      context "登録されている電力会社のIDと紐づく場合" do
        it 'バリデーションエラーにならないこと' do
          plan = build(:plan, provider: provider)
          expect(plan.valid?).to be true
        end
      end
    end

    describe '異常系' do
      context "登録されている電力会社のIDと紐づかない場合" do
        it 'バリデーションエラーになること' do
          plan = build(:plan)
          expect(plan.valid?).to eq false
        end
      end
      
      context "プラン名が空文字の場合" do
        it 'バリデーションエラーになること' do
          plan = build(:plan, provider: provider, name: "")
          expect(plan.valid?).to eq false
        end
      end
    end
  end
end