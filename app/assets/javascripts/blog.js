$(document).ready(function() {
    $.get(ghost.url.api('posts', {limit: 3})).done((data) => {
        let posts = []
        data.posts.forEach((post) => {
            posts.push(`<h2>${post.title}</h2><div>${post.html}</div>`)
        })
        $('#blog').append(posts)
    });
});
