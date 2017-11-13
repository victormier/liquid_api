LiquidApi.route("saltedge_callbacks") do |r|
  # Handle Saltedge callbacks: https://docs.saltedge.com/guides/callbacks/

  # A success callback is received whenever there's new data on a login.
  # On success we do the following:
  # - Update data about the login
  # - Update accounts based on the login
  # - Update transactions of the accounts
  r.post "success" do
    data = JSON.parse(request.body.read)
    login_id = data["data"]["login_id"]
    saltedge_login = SaltedgeLogin.find_by(saltedge_id: login_id)
    if saltedge_login
      Services::UpdateSaltedgeLogin.new(saltedge_login).call
      unless saltedge_login.saltedge_accounts.any?
        service = Services::RetrieveSaltedgeAccounts.new(saltedge_login)
        service.call
      end
    end
    [200, '']
  end

  r.post "failure" do
    data = JSON.parse(request.body.read)
    login_id = data["data"]["login_id"]
    saltedge_login = SaltedgeLogin.find_by(saltedge_id: login_id)
    if saltedge_login
      Services::UpdateSaltedgeLogin.new(saltedge_login).call
    end
    [200, '']
  end
end
