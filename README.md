To know more about RubyOptimize look at the [full documentation](https://github.com/adrdilauro/ruby_optimize/wiki/Full-documentation).

# Features

1. Set up an A/B test with a very **simple** and **descriptive code** (the gem consists of just three methods)
2. A/B tests are valid across different pages, using cookies
3. You can test **multiple versions** with changes as complicated as you need, while still keeping the code clean and understandable
4. Effortlessly set up **multiple A/B tests** that don't clash with each other (remembering of course to ensure that results of the tests are kept separated)
5. Very easy to select a special version for crawlers, so you don't affect your SEO while you are running the test
6. The gem is safe and super tested (https://github.com/adrdilauro/ruby_optimize/blob/master/spec/ruby_optimize_spec.rb)

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

#### (2) - Render the script that reads / writes the cookie
```html
<head>
  <%= ruby_optimize_init %>
  ...
</head>
```

#### (3) - Wrap blocks of HTML that will be rendered depending on the version
```html
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

# How it works

When you call `ruby_optimize_init` in your `.erb` files, you will render a simple synchronous script that

- tries to read the cookie relative to your A/B test
- if the cookie is not present, extract a random version among the ones you defined, and store it in a cookie
- save the version in an internal javascript object that will be used across the page

When you wrap a block of HTML inside `ruby_optimize_wrap`, passing a specific version, the block will be wrapped inside a `<div>` with a generated random id, and after the block it will be appended a synchronous `<script>` tag that looks like this:

```html
<script>
  window.rubyOptimizerObject.keepOrRemoveHtmlBlock('[random id]', '[version]');
</script>
```

If the version passed doesn't match with the version that has been stored on the top of the page, then the block is removed. This happens before the page is fully rendered, so there isn't any chance to get page flickering.

The synchronous scripts are really simple and don't slow down page rendering time.


# Why RubyOptimize is good for complex A/B tests

You can create several different versions of the same page, as complex and as big as you need, without filling your HTML with unnecessary code. This will make your A/B test less error prone, and also it will make it easier to remove the loser versions after the test, because the code is clear and descriptive.

You can easily span your tests across different pages reading the same cookie, with no additional code, RubyOptimize does all the work for you.

You can maintain as many different A/B tests you want without risking them to clash.

# Why RubyOptimize is good for small A/B tests as well

Usually, to set up a small A/B test (changing a color, removing or adding a div, etc) people use client side tools like Google Optimize.

This approach can potentially affect user experience, because Google Optimize has to change parts of the page depending on the specific version selected, and, if this happens while the user is already looking at the page, we have the effect called "page flickering". To prevent page flickering Google Optimize introduced a "hide-page tag", i.e. a script that hides the page until the external call to Google Optimize server has responded.

Now, usually Google Optimize tag loads fast, but you cannot always rely on external calls, especially in conditions of low network; in the worst scenario, if Google Optimize server doesn't respond, the hide-page tag gets unblocked after the threshold of 4 seconds.

This means that, even if your server has responded in 150 milliseconds, your user won't be able to see anything in the page until the 4 seconds have expired.

**Are you sure you want to risk this? With RubyOptimize you can set up a simple A/B test easily and cleanly directly in the code, this means that you can get rid of the hide-page tag, and let Google Optimize focus only on data collection.**
