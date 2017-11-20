module Services
  class KillUser
    DAYS_TO_KEEP_DATA = 30

    def initialize(user)
      @user = user
    end

    # Schedules a job that removes that leaves user inactive
    # and removes the user and its data 30 days from now
    def call
      User.transaction do
        remove_user_at = DAYS_TO_KEEP_DATA.days.from_now
        @user.update_attributes(will_be_removed_at: remove_user_at)
        RemoveUserWorker.perform_at(remove_user_at, @user.id)
      end
    end
  end
end
