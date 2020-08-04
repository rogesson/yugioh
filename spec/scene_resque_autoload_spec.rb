# require 'spec_helper'

# describe Scene_ResqueAutoload do


#   describe '#update' do
#     it 'reloads the source code if correct button was trigged' do
#       subject = Scene_ResqueAutoload.new

#       allow(Input).to receive(:trigger?)
#         .with(Scene_ResqueAutoload::RELOAD_BUTTON)
#         .and_return(true)

#       allow(subject).to receive(:reload)
#         .once
      
#       expect(subject.update).to eq(nil)
#       expect(subject).to have_received(:reload)
#     end
#   end

#   describe '#reload' do
#     it "puts reloading and autload source code" do
#       subject = Scene_ResqueAutoload.new

#       expect(subject.send(:reload)).to eq(nil)
#     end
#   end
# end