$ ->

  $('.setup-boat').on 'click', ->
    $('.setup-boat').removeClass('active')
    $(this).addClass('active')
    size = $(@).data('size')

  $('.setup .grid').on 'click', 'li', (e) ->
    debugger
    return unless $('.setup-boat.active').length
    boatName = $('.setup-boat.active').data('name')
    href = window.location.pathname + '/add_boat'
    debugger
    $.post href, boat_name: boatName, space: $(e.target).text()

