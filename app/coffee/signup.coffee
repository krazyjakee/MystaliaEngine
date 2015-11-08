$(window).load ->
  $('form').submit (e) ->
    e.preventDefault()
    $.ajax
      url: $(@).attr('action')
      type: 'post'
      data: $(@).serialize()
      success: (response) ->
        if response.error
          alert response.error
        else if response.username
          username = $('#register-form input[name="username"]').val()
          password = $('#register-form input[name="password"]').val()
          $('#login-form input[name="username"]').val username
          $('#login-form input[name="password"]').val password
          $('#login-form button').click()
        else if response.auth
          window.localStorage['auth'] = response.auth
          location.href = "/play"
					console.log(response)
   	false