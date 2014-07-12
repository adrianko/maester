(($) ->
    component_stash = {}
    board_delete = ""
    board_edit = ""
    board_action = ""

    modalLabels = () ->
        if board_action == "edit"
            $("#board-modal .modal-dialog .modal-content .modal-header .modal-title").text "Edit board"
            $("#board-modal-submit").text "Update"
        else
            $("#board-modal .modal-dialog .modal-content .modal-header .modal-title").text "Add board"
            $("#board-modal-submit").text "Add"
        undefined

    $(document.body).on "click", ".new-board", ->
        board_action = "new"
        modalLabels()
        $("#board-modal-title").val ""
        $("#board-modal-desc").val ""
        $("#board-modal-bg").val "#ffffff"
        $("#board-modal-bg").attr "value", "#ffffff"
        $(".input-group").colorpicker "setValue", "#ffffff"
        $("#board-modal").modal "show"
        undefined

    $(document.body).on "click", "#board-modal-submit", ->
        title = $("#board-modal-title").val()
        description = $("#board-modal-desc").val()
        background = $("#board-modal-bg").val()
        $("#board-modal").modal "hide"
        if board_action == "new"
            component = 0
            if "boarditem" not of component_stash
                component = 1
            $.ajax
                type: "POST"
                url: "/api/set/board/new"
                data:
                    component: component
                    title: title
                    description: description
                    background: background
                success: (data) ->
                    if data.code != 200
                        console.log "ERROR: "+data.code
                    if component is 1
                        component_stash.boarditem = data.data.components
                    board = component_stash.boarditem
                    board = board.split "{{ b.id }}"
                    board = board.join data.data.id
                    board = board.replace "{{ b.title }}", title
                    board = board.replace "{{ b.description }}", description
                    board = board.split "{{ b.background }}"
                    board = board.join data.data.background
                    $(".boards").eq(0).append board
                    $("#board-modal").modal "hide"
                error: (jqXHR, textStatus, err) ->
                    console.log err
        else
            $.ajax
                type: "POST"
                url: "/api/set/board/update"
                data:
                    id: board_edit
                    title: title
                    description: description
                    background: background
                success: (data) ->
                    if data.code != 200
                        console.log "ERROR: "+data.code
                    $(".boards .board-item[data-board='"+board_edit+"'] .board-title").text title
                    $(".boards .board-item[data-board='"+board_edit+"'] .board-description").text description
                    $(".boards .board-item[data-board='"+board_edit+"']").attr "data-background", background
                    $(".boards .board-item[data-board='"+board_edit+"']").css "background", background
                    $("#board-modal").modal "hide"
                    board_edit = ""
                error: (jqXHR, textStatus, err) ->
                    console.log err
        board_action = ""
        undefined

    $(document.body).on "click", ".board-link", ->
        window.location.href = $(@).attr "data-href"
        undefined

    $(document.body).on "click", ".board-dd", (e) ->
        e.preventDefault()
        e.stopPropagation()
        $(@).dropdown("toggle")
        undefined

    $(document.body).on "click", ".board-edit", (e) ->
        e.preventDefault()
        e.stopPropagation()
        board_edit = $(@).attr "data-id"
        board_action = "edit"
        bg_col = "#"+$(@).closest(".board-item").attr "data-background"
        modalLabels()
        $("#board-modal-title").val($(@).closest(".board-item").find(".board-title").text())
        $("#board-modal-desc").val($(@).closest(".board-item").find(".board-description").text())
        $("#board-modal-bg").attr "value", bg_col
        $(".input-group").colorpicker "setValue", bg_col
        $("#board-modal").modal "show"
        undefined

    $(document.body).on "click", ".board-delete", (e) ->
        e.preventDefault()
        e.stopPropagation()
        board_delete = $(@).attr "data-id"
        $("#delete-board-modal").modal "show"
        undefined

    $(document.body).on "click", "#delete-board-no", ->
        $("#delete-board-modal").modal "hide"
        undefined

    $(document.body).on "click", "#delete-board-yes", ->
        $.ajax
            type: "POST"
            url: "/api/set/board/delete"
            data:
                id: board_delete
            success: (data) ->
                if data.code != 200
                    console.log "ERROR: "+data.code
                $(".boards .board-item[data-board='"+board_delete+"']").remove()
                $("#delete-board-modal").modal "hide"
                board_delete = ""
            error: (jqXHR, textStatus, err) ->
                console.log err
        undefined

    $(".input-group").colorpicker()
) jQuery
