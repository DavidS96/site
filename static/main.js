$('#slider').slick({
    dots: true,
    infinite: true,
    speed: 300,
    slidesToShow: 1,
    adaptiveHeight: true,
    autoplay: true,
    autoplaySpeed: 2000
});

document.getElementById('button').addEventListener('click',
    function () {
        document.querySelector('.modal-holder').style.display = 'flex';
    });

document.querySelector('.close').addEventListener('click',
    function () {
        document.querySelector('.modal-holder').style.display = 'none';
    });