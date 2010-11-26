module Mogli
  class FbAppUser < User
    attr_reader :id

    @@client = nil

    def self.set_client client
      @@client = client
    end

    def initialize id
      @@client = FbAppClient.new if @@client.nil?
      @id = id
      super({},@@client)
    end

    def dashboard_addNews params
      return nil if !params.key?('news')
      params['uid'] = @id
      response = @@client.old_api('dashboard.addNews', params)
      response['dashboard_addNews_response']
    end

    def user_hasAppPermission permission, callback = nil
      params = {
              'uid' => @id,
              'ext_perm' => permission
      }
      params['callback'] = callback unless callback.nil?
      @@client.old_api('users.hasAppPermission', params)
    end

    def to_s
      @id.to_s
    end
  end
end