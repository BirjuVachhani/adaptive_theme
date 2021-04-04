### Requirements

* Filling out the template is required. Any pull request that does not include enough information to be reviewed in a timely manner may be closed at the maintainers' discretion.
* All new code requires tests to ensure against regressions

### Description of the Change

<!--

adding an additional getter lightTheme and changing the getter darkTheme to always returning the dark theme instead of returning the current theme.

-->

### Alternate Designs

<!-- instead of the additional getter, the getter theme could alway return the lightTheme -->

### Why Should This Be In Core?

<!-- mode independend getter for the modes are necesseray, if you need it for example in a theme settings screen -->

### Benefits

<!-- usability improved in case of theme setting screens -->

### Possible Drawbacks

<!-- not known -->

### Verification Process

<!--

What process did you follow to verify that your change has the desired effects?

- manual test with example

manually compared the themes from getter lightTheme and darkTheme

-->

### Applicable Issues

<!-- not known -->
