AC_INIT([conffiles], [1.0])

AC_CONFIG_FILES([feh/fehbg])

AC_SUBST(background_image, [$HOME/Pictures/default_background.png])

AC_ARG_WITH(
  background_image,
  AS_HELP_STRING([--with-background_image=IMG], [Background image location]),
  [background_image="$withval"]
)

AC_OUTPUT
