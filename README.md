# Features

1. Set up an A/B test with a very **simple** and **descriptive code** (the gem consists of just two methods)
2. A/B tests are valid across different pages, using cookies
3. You can test **multiple versions** with changes as complicated as you need, while still keeping the code clean and understandable
4. Effortlessly set up **multiple A/B tests** that don't clash with each other (remembering of course to ensure that results of the tests are kept separated)
5. Very easy to select a special version for crawlers, so you don't affect your SEO while you are running the test

# Usage

Install it using bundler
```ruby
gem 'ruby_optimize'
```

#### (1) - Initialize the A/B test in the actions you need inside the controller
```ruby
before_action :initialize_ab_test

def initialize_ab_test
  ruby_optimize [ :v1, :v2, :v3 ] # Declare the names of all the versions you are going to test
end
```
..or in the specific `.erb` file where you need to set up the test, if the test is localized in only one place

```HTML+ERB
<% ruby_optimize [ :v1, :v2, :v3 ] %>
```

#### (2) - Wrap blocks of HTML that will be rendered depending on the version
```HTML+ERB
<%= ruby_optimize_wrap(:v1) do %>
  <div class="for-version-1">
    ...
  </div>
<% end %>

<%= ruby_optimize_wrap(:v2) do %>
  <div class="for-version-2">
    ...
  </div>
<% end %>
```


# Why RubyOptimize is good for complex A/B tests

You can create several different versions of the same page, as complex and as big as you need, without filling your HTML with unnecessary code. This will make your A/B test less error prone, and also it will make it easier to remove the loser versions after the test, because the code is clear and descriptive.

You can easily span your tests across different pages reading the same cookie, with no additional code, RubyOptimize does all the work for you.

You can maintain as many different A/B tests you want without risking them to clash.


# Why RubyOptimize is good for small A/B tests as well

Usually, to set up a small A/B test (changing a color, removing or adding a div, etc) people use client side tools like Google Optimize.

This approach can potentially affect user experience, because Google Optimize has to change parts of the page depending on the specific version selected, and, if this happens while the user is already looking at the page, we have the effect called "page flickering". To prevent page flickering Google Optimize introduced a "hide-page tag", i.e. a script that hides the page until the external call to Google Optimize server has responded.

Now, usually Google Optimize tag loads fast, but you cannot always rely on external calls, especially in conditions of low network; in the worst scenario, if Google Optimize server doesn't respond, the hide-page tag gets unblocked after the threshold of 4 seconds.

This means that, even if your server has responded in 150 milliseconds, your user won't be able to see anything in the page until the 4 seconds have expired.

Are you sure you want to risk this? With RubyOptimize you can set up a simple A/B test easily and cleanly directly in the code, this means that you can get rid of the hide-page tag, and let Google Optimize focus only on data collection.


# How it works

### Initialization of a test

When you call `ruby_optimize` in your controller or `.erb` file, RubyOptimize instantiates a new `AbTestHandler` object scoped for that test, and appends it to a global variable that collects all the tests; this way there is a specific object that handles each separate test, and your tests won't clash.

Each `AbTestHandler` object saves data to its own cookie: the first thing it does when it gets initialised is verifying if the cookie is already present: if it's not present, it extracts a random version among the ones you defined.

### Wrapping a block of HTML

When you wrap a block of HTML inside `ruby_optimize_wrap`, the helper method finds the corresponding `AbTestHandler` object and asks it whether the block has to be rendered. The `AbTestHandler` object takes it decision based on which version has stored internally, and on whether the request comes from a crawler.


# Examples of configuration


### 1 - Simplest configuration

```ruby
ruby_optimize([ :v1, :v2, :v3 ]
```

A test is initialized containing three different versions, each having one third of probability to be extracted.


### 2 - Initialize more than one test

```ruby
ruby_optimize([ :small, :large ]
ruby_optimize([ :old, :new ], scope: :first_test
ruby_optimize([ :v1, :v2, :v3 ], scope: :second_test
```

To set up more than one test, you have to specify a `:scope`, which has to be an alphanumeric symbol. You can't define more than one test associated to the same scope.

When you don't specify the `:scope` option, it automatically gets the value of `:default`.


### 3 - Initialization options

```ruby
# If not specified, domain defaults to :all
ruby_optimize [ :v1, :v2 ], domain: 'www.example.com'
```
```ruby
# Cookie expiration can be either an integer or a Time instance
# If not specified, it defaults to 180 days
ruby_optimize [ :v1, :v2 ], cookie_expiration: 1.month
```
```ruby
# Version :old will always be the one shown to crawlers, without need to specify it case per case
ruby_optimize [ :old, :new ], version_for_crawler: :old
```
```ruby
# The cookie is stored in Rails session
ruby_optimize [ :old, :new ], session_cookie: true
```
```ruby
# If you use :session_cookie together with :cookie_expiration, the cookie is stored in session and :cookie_expiration is ignored
# Another option that is ignored if you use :session_cookie is :domain
ruby_optimize [ :old, :new ], session_cookie: true, cookie_expiration: 1.month
```

### Weighted versions

You can wrap a version in a two elements array, inserting an integer or a float as second element. This number will be used to do a weighted extraction.

To calculate all the weights, RubyOptimize sums the weights you explicitly specified, and divides equally the remaining versions. If the sum of the weights you specified is over 100, you'll get an error.

```ruby
ruby_optimize [ [:v1, 40], :v2, :v3 ]  # 40% - 30% - 30%
ruby_optimize [ [:v1, 90], [:v2, 9], :v3 ]  # 90% - 9% - 1%
ruby_optimize [ [:v1, 50], [:v2, 55], :v3 ]  # Exception raised
ruby_optimize [ [:v1, 40], [:v2, 30], [:v3, 35] ]  # Exception raised
```

An example that combines more options

```ruby
ruby_optimize [ :v1, :v2, [:v3, 40] ], scope: :navbar_test, session_cookie: true, domain: 'test.example.com'
```

### Wrap options

```HTML+ERB
<%= ruby_optimize_wrap(:v1) do %>
  <!-- Rendered if visit doesn't come from a crawler and the version extracted is :v1 -->
  <!-- Rendered if visit comes from a crawler and you have previously set up :v1 as global version for crawlers -->
  <div>Hello World</div>
<% end %>
```

Scope is `:default`. The version passed needs to be present and be one of the ones defined on `:default` scope

```HTML+ERB
<%= ruby_optimize_wrap(:v1, :some_scope) do %>
  <!-- Rendered if visit doesn't come from a crawler and the version extracted is :v1 -->
  <!-- Rendered if visit comes from a crawler and you have previously set up :v1 as global version for crawlers under scope :some_scope -->
  <div>Hello World</div>
<% end %>
```

The only difference is that we explicitly selected scope `:some_scope`, so `:v1` must match one version defined in that scope rather than in `:default`

An exception is raised if the selected scope doesn't correspond to any `AbTestHandler` previously initialized.

```HTML+ERB
<%= ruby_optimize_wrap(:v1, :some_scope, version_for_crawler: true) do %>
  <!-- Rendered if visit doesn't come from a crawler and the version extracted is :v1 -->
  <!-- Rendered if visit comes from a crawler, regardless of how you configured the test -->
  <div>Hello World</div>
<% end %>

<%= ruby_optimize_wrap(:v1, version_for_crawler: true) do %>
  <!-- Rendered if visit doesn't come from a crawler and the version extracted is :v1 -->
  <!-- Rendered if visit comes from a crawler, regardless of how you configured the test -->
  <div>Hello World</div>
<% end %>
```

The final example covers the case when you want to prepare a special version that is ONLY shown to crawlers

```HTML+ERB
<%= ruby_optimize_wrap(version_for_crawler: true) do %>
  <!-- Rendered only if visit comes from a crawler -->
  <div>Hello Crawler</div>
<% end %>
```

This is the only case in which it's acceptable not to set a version. Scope is not necessary because this HTML doesn't affect any of our tests
