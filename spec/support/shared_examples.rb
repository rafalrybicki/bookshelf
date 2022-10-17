shared_examples 'requires login' do |http_method, path|
  let(:expected_path) { instance_exec(&path) }

  context 'when not logged in' do
    it 'redirects to login page' do
      logout
      send(http_method, expected_path)
      expect(response).to redirect_to new_user_session_path
    end
  end
end

shared_examples 'requires owner' do |http_method, path|
  let(:expected_path) { instance_exec(&path) }

  it 'redirects to root page when the user is not the owner' do
    send(http_method, expected_path)
    expect(response).to redirect_to root_path
  end
end
