$(function () {
    var sound = new Audio('sound.mp3');
    var wait = 0;
    sound.volume = 0.3;
    window.addEventListener('message', function (event) {
        if (event.data.action == 'open') {
            if (wait < 3) {
                var number = Math.floor((Math.random() * 1000) + 1);
                wait++;
                $('.toast').append(`
                <div class="wrapper-${number}">
                    <div class="notification_main-${number}">
                        <div class="title-${number}"></div>
                        <div class="text-${number}">
                            ${event.data.message}
                        </div>
                    </div>
                </div>`)
                $(`.wrapper-${number}`).css({
                    "margin-bottom": "10px",
                    "width": "275px",
                    "margin": "0 0 8px -180px",
                    "clip-path": "polygon(0 0, 100% 0, 100% 100%, 7% 100%)"
                })
                $('.notification_main-'+number).addClass('main')
                $('.text-'+number).css({
                    "font-size": "14px"
                })

                if (event.data.type == 'success') {
                    $(`.title-${number}`).html(event.data.title).css({
                        "font-size": "16px",
                        "font-weight": "600",
                        "color": '#fff'
                    })
                    $(`.notification_main-${number}`).addClass('success-icon')
                    $(`.wrapper-${number}`).addClass('success')
                    sound.play();
                } else if (event.data.type == 'info') {
                    $(`.title-${number}`).html(event.data.title).css({
                        "font-size": "16px",
                        "font-weight": "600",
                        "color": '#fff'
                    })
                    $(`.notification_main-${number}`).addClass('info-icon')
                    $(`.wrapper-${number}`).addClass('info')
                    sound.play();
                } else if (event.data.type == 'error') {
                    $(`.title-${number}`).html(event.data.title).css({
                        "font-size": "16px",
                        "font-weight": "600",
                        "color": '#fff'
                    })
                    $(`.notification_main-${number}`).addClass('error-icon')
                    $(`.wrapper-${number}`).addClass('error')
                    sound.play();
                } else if (event.data.type == 'warning') {
                    $(`.title-${number}`).html(event.data.title).css({
                        "font-size": "16px",
                        "font-weight": "600",
                        "color": '#fff'
                    })
                    $(`.notification_main-${number}`).addClass('warning-icon')
                    $(`.wrapper-${number}`).addClass('warning')
                    sound.play();
                } else if (event.data.type == 'phonemessage') {
                    $(`.title-${number}`).html(event.data.title).css({
                        "font-size": "16px",
                        "font-weight": "600",
                        "color": '#fff'
                    })
                    $(`.notification_main-${number}`).addClass('phonemessage-icon')
                    $(`.wrapper-${number}`).addClass('phonemessage')
                    sound.play();
                } else if (event.data.type == 'neutral') {
                    $(`.title-${number}`).html(event.data.title).css({
                        "font-size": "16px",
                        "font-weight": "600",
                        "color": '#fff'
                    })
                    $(`.notification_main-${number}`).addClass('neutral-icon')
                    $(`.wrapper-${number}`).addClass('neutral')
                    sound.play();
                }
                anime({
                    targets: `.wrapper-${number}`,
                    translateX: -50,
                    duration: 750,
                    easing: 'spring(1, 70, 100, 10)',
                })
                setTimeout(function () {
                    anime({
                        targets: `.wrapper-${number}`,
                        translateX: 500,
                        duration: 750,
                        easing: 'spring(1, 80, 100, 0)'
                    })
                    setTimeout(function () {
                        $(`.wrapper-${number}`).remove()
                        wait--;
                    }, 750)
                }, event.data.time)
            }
        }
    })
})
