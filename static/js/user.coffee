(($) ->

    $(document.body).on "click", ".add-user", ->
        $("#user-modal-username").val ""
        $("#user-modal-email").val ""
        undefined

    $(document.body).on "click", "#user-modal-submit", ->
        username = $("#user-modal-username").val()
        email = $("#user-modal-email").val()
        $.ajax
            type: "POST"
            url: "/api/set/user/new"
            data:
                username: username
                email: email
            success: (data) ->
                if data.code != 200
                    console.log "ERROR: "+data.code
                $(".users-list .panel-body .list").append "<li>"+username+"</li>"
            error: (jqXHR, textStatus, err) ->
                console.log err
            $("#user-modal").modal "hide"
        undefined

) jQuery
