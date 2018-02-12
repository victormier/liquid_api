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

      if saltedge_login.saltedge_accounts.any?
        saltedge_login.saltedge_accounts.each do |saltedge_account|
          UpdateSaltedgeAccountWorker.perform_async(saltedge_account.id)
        end
      else
        Services::RetrieveSaltedgeAccounts.new(saltedge_login).call
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

      if saltedge_login.new_login_and_invalid?
        # Kills local saltedge_login (destroyed in 1 day) and
        # destroys remote login (saltedge reference)
        Services::RemoveSaltedgeLogin.new(saltedge_login).call
      end
    end
    [200, '']
  end

  r.post "interactive" do
    data = JSON.parse(request.body.read)
    login_id = data["data"]["login_id"]
    saltedge_login = SaltedgeLogin.find_by(saltedge_id: login_id)
    if saltedge_login
      saltedge_login.update_attributes(interactive_data: data["data"])
    end
    [200, '']
  end
end
