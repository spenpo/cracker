import { Stack, Typography } from '@mui/material'
import { WP_REST_URI } from '../constants/blog'
interface Post {
  content: {
    rendered: string
  }
}

const getPost = async () =>
  fetch(`${WP_REST_URI}/pages?slug=about`).then((res) => res.json())

export async function getStaticProps() {
  const post = await getPost().then((res) => res?.[0])
  return {
    props: {
      post,
    },
  }
}

export default function About({ post }: { post: Post }) {
  return (
    <Stack flex={1}>
      <Stack maxWidth="50em" mx="auto" mb="auto" p={{ xs: 2, sm: 5 }} gap={5}>
        <Typography variant="h3">About Cracker</Typography>
        <Typography
          variant="body2"
          dangerouslySetInnerHTML={{ __html: post.content.rendered }}
          component="div"
          sx={{
            '.wp-block-embed__wrapper': {
              width: '500px',
              margin: '0 auto',
            },
          }}
        />
      </Stack>
    </Stack>
  )
}