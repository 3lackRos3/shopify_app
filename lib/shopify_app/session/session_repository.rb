# frozen_string_literal: true
module ShopifyApp
  class SessionRepository
    class ConfigurationError < StandardError; end

    class << self
      attr_writer :shop_storage

      attr_writer :user_storage

      def retrieve_shop_session(id)
        shop_storage.retrieve(id)
      end

      def retrieve_user_session(id)
        user_storage.retrieve(id)
      end

      def retrieve_shop_session_by_shopify_domain(shopify_domain)
        shop_storage.retrieve_by_shopify_domain(shopify_domain)
      end

      def retrieve_user_session_by_shopify_user_id(user_id)
        user_storage.retrieve_by_shopify_user_id(user_id)
      end

      def store_shop_session(session, scopes)
        shop_storage.store(session, scopes)
      end

      def store_user_session(session, user)
        user_storage.store(session, user)
      end

      def update_scopes(shop_session, scopes)
        missing_scopes = scopes - shop_session.extra[:scopes] if shop_session.present?
        shop_storage.store(shop_session, scopes) unless missing_scopes.nil? || missing_scopes.empty?
      end

      def shop_storage
        load_shop_storage || raise(ConfigurationError, "ShopifySessionRepository.shop_storage is not configured!")
      end

      def user_storage
        load_user_storage
      end

      private

      def load_shop_storage
        return unless @shop_storage
        @shop_storage.respond_to?(:safe_constantize) ? @shop_storage.safe_constantize : @shop_storage
      end

      def load_user_storage
        return NullUserSessionStore unless @user_storage
        @user_storage.respond_to?(:safe_constantize) ? @user_storage.safe_constantize : @user_storage
      end
    end
  end
end
