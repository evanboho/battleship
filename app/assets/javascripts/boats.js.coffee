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

