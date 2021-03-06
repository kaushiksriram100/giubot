require 'sinatra'
require 'httparty'
require 'json'

#get
get '/test' do
  'Hello world!'
end


#post
post '/sensu' do
#return if params[:token] != 'fJadxB8bfPLEGC2VaEbVMCo3'
	message = params[:text].gsub(params[:trigger_word], '').strip

	action, repo = message.split('_').map {|c| c.strip.downcase }
	repo_url = "https://api.github.com/repos/#{repo}"

	case action
		when 'issues'
			resp = HTTParty.get(repo_url)
			resp = JSON.parse resp.body
			response_message "There are #{resp['open_issues_count']} open on #{repo}"
		end
end


def response_message message
	content_type :json
	{:text => message}.to_json
end
