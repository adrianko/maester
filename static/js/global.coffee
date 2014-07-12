(($) ->
    $.ajaxSetup
        beforeSend: (xhr, settings) ->
            unless (/^https?:.*/.test settings.url)
                xhr.setRequestHeader "X-CSRFToken", $("#csrf_token").val()
    undefined
) jQuery
