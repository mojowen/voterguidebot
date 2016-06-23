//= require turbolinks
//= require react
//= require react_ujs
//= require vanilla-ujs
//= require underscore
//= require superagent
//= require dropzone
//= require sweetalert
//= require_tree ./mixins
//= require_tree ./components


window.vgConfirm = function(question, callback, context) {
  swal(
    {
      title: "Are you sure?",
      text: question,
      type: "warning",
      showCancelButton: true,
      confirmButtonColor: "#FF4081;",
      confirmButtonText: "Yes",
      cancelButtonText: "No, cancel",
      closeOnConfirm: true,
      closeOnCancel: true,
      allowOutsideClick: true,
      allowEscapeKey: true
    },
    function(isConfirm) {
      callback.call(context, isConfirm)
    }
  )
}

