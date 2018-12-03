AC_INIT([conffiles], [1.0])

AC_CONFIG_FILES([feh/fehbg])

AC_SUBST(background_image, [$HOME/Pictures/default_background.png])


# Checks for command line options

AC_ARG_ENABLE(
  [feh], [--disable-feh    disable feh],
  [conf_feh=${enableval}],
  [conf_feh=yes]
)

AC_ARG_WITH(
  background_image,
  AS_HELP_STRING([--with-background_image=IMG], [Background image location]),
  [background_image="$withval"]
)


# feh
if test "x${conf_feh}" = xyes; then
  AC_CHECK_PROG(feh_check, feh, yes)
  if test x"$feh_check" != x"yes" ; then
    AC_MSG_ERROR([Please install feh.])
  fi
fi

AC_OUTPUT
