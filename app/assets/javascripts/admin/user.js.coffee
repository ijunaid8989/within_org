sendAJAXRequest = (settings) ->
  token = $('meta[name="csrf-token"]')
  if token.size() > 0
    headers =
      "X-CSRF-Token": token.attr("content")
    settings.headers = headers
  xhrRequestChangeMonth = jQuery.ajax(settings)

users_table = undefined

initializeDataTable = ->
  users_table = $("#users_datatables").DataTable
    aaSorting: [1, "asc"]
    aLengthMenu: [
      [25, 50, 100, 200, -1]
      [25, 50, 100, 200, "All"]
    ]
    columns: [
      {data: "0", sWidth: "55px" },
      {data: "1", sWidth: "145px" },
      {data: "2", sWidth: "100px" },
      {data: "3", sWidth: "150px" },
      {data: "4", sWidth: "150px" },
      {data: "5", sWidth: "150px" },
      {data: "6", sWidth: "50px" },
    ],
    iDisplayLength: 500
    columnDefs: [
      type: "date-uk"
      targets: 'datatable-date'
    ],
    "oLanguage": {
      "sSearch": "Filter:"
    },
    initComplete: ->
      # $("#archive_datatables_length").hide()
      # $("#div-dropdown-checklist").css({"visibility": "visible", "width": "57px", "top": "0px", "left": "6px" })
      #do something here

onAddUser = ->
  $("#add-user").on "click", ->
    $("#modal-add-user").modal("show")

addUser = ->
  $("#save-user").on "click", ->
    data = {}
    data.firstname = $("#firstname").val()
    data.lastname = $("#lastname").val()
    data.username = $("#username").val()
    data.is_first_login = true

    company_data = $("#company-data").val().split(':')
    data.company_id = company_data[0]
    username = $("#username").val()
    data.email = "#{username}@#{company_data[1]}"

    onError = (jqXHR, status, error) ->
      $(".error-on-save")
        .removeClass "hidden"
        .text "#{jqXHR.responseText}"
      false

    onSuccess = (result, status, jqXHR) ->
      console.log result
      $('#modal-add-user').modal('hide')
      clearForm()
      addNewRow(result)
      $(".congrats-on-save")
        .removeClass "hidden"
        .delay(200)
        .fadeIn()
        .delay(4000)
        .fadeOut()
      $(".error-on-save")
        .addClass "hidden"
        .text ""
      true

    settings =
      cache: false
      data: data
      dataType: 'json'
      error: onError
      success: onSuccess
      contentType: "application/x-www-form-urlencoded"
      type: "POST"
      url: "/users/new"

    sendAJAXRequest(settings)

clearForm = ->
  $("#firstname").val("")
  $("#lastname").val("")
  $("#username").val("")

addNewRow = (user) ->
  users_table.row.add([
    "#{user.id}",
    "#{user.firstname} #{user.lastname}",
    "#{user.username}",
    "#{user.email}",
    "#{user.company.company_name}",
    "#{formatDate(user.created_at)}",
    "<i user-id='#{user.id}' class='fa fa-trash-o delete-user'></i>"
  ]).draw()

formatDate = (date) ->
  date = new Date(date)
  date.toUTCString()

window.initializeUser = ->
  initializeDataTable()
  onAddUser()
  addUser()
  # onSaveCompany()
  # onClose()