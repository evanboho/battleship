submitGuess = ($el) ->
  url = $el.attr('href').replace('?', '.json?')
  $.post url, (response) ->
    switch response.computer_board.state
      when 'already guessed'
        alert 'You already guessed that space'
      when 'invalid guess'
        alert 'You somehow guessed a space that is not on the board.'
      else
        computerBoardGuess = response.computer_board.letter + response.computer_board.number
        humanBoardGuess = response.human_board.letter + response.human_board.number
        $("table.computer td.space[data-letter='#{response.computer_board.letter}'][data-number='#{response.computer_board.number}']")
          .addClass(response.computer_board.state)
        $("table.human td.space[data-letter='#{response.human_board.letter}'][data-number='#{response.human_board.number}']")
          .addClass(response.human_board.state)
        if $('table.computer td.hit').length == 17 || $('table.human td.hit').length == 17
          window.location.reload()

$ ->

  $('.setup-boat').on 'click', ->
    $('.setup-boat').removeClass('active')
    $(this).addClass('active')
    size = $(@).data('size')

  $('.setup .grid').on 'click', 'td', (e) ->
    return unless $('.setup-boat.active').length

    boatName = $('.setup-boat.active').data('name')
    href = window.location.pathname + '/add_boat'
    space = 'a1'
    space = space.split('')
    $.post href, boat_name: boatName, letter: space[0], number: space[1]


  $('button.space').on 'click', (e) ->
    if $(@).closest('td').hasClass('hit') || $(@).closest('td').hasClass('guessed')
      return false
    try
      submitGuess $(@).find('a')
    return false

  $('input[type=radio]').on 'change', ->
    $(this).closest('form').submit()
