require 'spec_helper'

describe Lita::Handlers::PivotalTracker, lita_handler: true do

  let(:projects) do
    File.read('spec/files/projects.json')
  end

  let(:story) do
    File.read('spec/files/story.json')
  end

  it { routes_command('pt add').to(:pt_add) }

  before do
    Lita.config.handlers.pivotal_tracker = Lita::Config.new
    Lita.config.handlers.pivotal_tracker.tap do |config|
      config.token = "TOKEN"
    end
  end

  def grab_request(method, status, body)
    response = double('Faraday::Response', status: status, body: body)
    expect_any_instance_of(Faraday::Connection).to \
      receive(method.to_sym).and_return(response)
  end

  describe '#pt_add' do
    it 'adds a story' do
      grab_request('get', 200, projects)
      grab_request('post', 200, story)
      send_command("pt add -p 'Death Star' -n 'Exhaust ports are ray shielded'")
      expect(replies.last).to eq("BAM! Added Feature 'Exhaust ports are ray shielded' to 'Death Star' http://localhost/story/show/2300")
    end
  end
end
