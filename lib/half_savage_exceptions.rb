module HalfSavageExceptions
  class ForumPermissionException < Exception; end
  class MustBePaidException < ForumPermissionException; end
  class MustBeModeratorException < ForumPermissionException; end
  class MustBeAuthenticatedException < ForumPermissionException; end
  class MustNotBeBannedException < ForumPermissionException; end
  class MustNotBeInactiveException < ForumPermissionException; end
end
