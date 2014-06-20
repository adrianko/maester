(($) ->
    $.ajaxSetup
        beforeSend: (xhr, settings) ->
            unless (/^https?:.*/.test settings.url)
                xhr.setRequestHeader "X-CSRFToken", $("#csrf_token").val()#getCookie "csrftoken"

    getCookie = (name) ->
        for cookie in document.cookie.split ";" when cookie and name is (cookie.split "=")[0]
            return decodeURIComponent cookie[(1 + name.length)...]
        null

    undefined
) jQuery
