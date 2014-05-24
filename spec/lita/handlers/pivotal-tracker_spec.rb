require 'spec_helper'

describe Lita::Handlers::PivotalTracker, lita_handler: true do

  let(:projects) do
    File.read('spec/files/projects.json')
  end

  let(:feature) do
    File.read('spec/files/feature.json')
  end

  let(:bug) do
    File.read('spec/files/bug.json')
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

  describe 'missing config' do
    before { Lita.config.handlers.pivotal_tracker.token = nil }
    it 'should raise an error' do
      expect { send_command('pt add some feature to some project') }.to raise_error('Missing token')
    end
  end

  describe '#pt_add' do
    it 'adds a bug' do
      grab_request('get', 200, projects)
      grab_request('post', 200, bug)
      send_command("pt add bug Explosive chain reaction in exhaust ports to Death Star")
      expect(replies.last).to eq("BAM! Added Bug 'Explosive chain reaction in exhaust ports' to 'Death Star' http://localhost/story/show/806")
    end

    it 'defaults to feature' do
      grab_request('get', 200, projects)
      grab_request('post', 200, feature)
      send_command("pt add Exhaust ports are ray shielded to Death Star")
      expect(replies.last).to eq("BAM! Added Feature 'Exhaust ports are ray shielded' to 'Death Star' http://localhost/story/show/2300")
    end

    it 'responds with the help info if called incorrectly' do
      send_command("pt add")
      expect(replies.last).to eq("USAGE: (pt|pivotaltracker) add [feature | bug | chore] <name> to <project>")
    end

    context 'project not found' do
      it 'responds with an error' do
        grab_request('get', 200, projects)
        send_command("pt add Some story to a project that does not exist")
        expect(replies.last).to eq("Couldn't find project with name containing 'a project that does not exist'")
      end
    end
  end
end
