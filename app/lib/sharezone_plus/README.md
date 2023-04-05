# Sharezone Plus

In our app users can subscribe to a paid tier called "Sharezone Plus". With this
subscription features can be unlocked that are only accessible to paid users. 

Sharezone Plus is available for the different user types under the same name but
technically as different subscriptions (i.e. `sharezone_plus_teacher`,
`sharezone_plus_student`, `sharezone_plus_parent`). This means that prices and
unlocked features may differ between the different versions of "Sharezone Plus".

### Multiple subscriptions, different user types

Some users may switch account types (e.g. from `parent` to `teacher`) over the
lifetime of their accounts. As we have different Sharezone Plus subscriptions
per user type, this may lead to unexpected behavior.

From the perspective of the Play Store / App Store the user can have several
subscriptions, in our `AppUser` model we only work with one active subscription.

This means that there is the edge-case that a users have several subscriptions,
but only one is active from our perspective. This shouldn't be a problem, except
for the case that the user switches account types and has a subscription for the
old account type that is still active or that the user activates another
subscription from "outside" (e.g. via the Play Store).

For now 
* we will warn the user if they switch account types that they should cancel
  their old subscription
* only consider the last subscription that was activated as the active
  subscription inside Firestore/`AppUser`.

If this leads to confusion we may need to change this behavior.
