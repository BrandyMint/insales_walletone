describe Payment, type: :model do
  subject { Fabricate(:payment) }

  it { expect(subject.status).to eq('created') }
end
