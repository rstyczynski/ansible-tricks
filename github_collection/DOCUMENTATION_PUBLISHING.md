# Publishing Collection Documentation to GitHub Pages

## Ansible Documentation Location Standards

According to Ansible's official documentation, collection documentation should be located in:

- **Standard location**: `docs/` directory at the collection root
- **HTML documentation**: `docs/html/` subdirectory
- **Current location in this project**: 
  ```
  github_collection/collections/ansible_collections/rstyczynski/github/docs/html/
  ```

This follows Ansible's best practices as documented in:
- https://docs.ansible.com/projects/ansible/latest/dev_guide/developing_collections_documenting.html

## GitHub Pages Publishing

### Yes, GitHub Pages Can Publish Your Documentation!

GitHub Pages supports publishing static HTML documentation. The modern approach uses **GitHub Actions** (not branch-based deployment).

### Setup Instructions

1. **Enable GitHub Pages in Repository Settings:**
   - Go to your repository on GitHub
   - Navigate to **Settings** → **Pages**
   - Under **Build and deployment**:
     - **Source**: Select **GitHub Actions** (not "Deploy from a branch")
   - Click **Save**

2. **The GitHub Actions Workflow:**
   - A workflow file has been created at: `.github/workflows/docs.yml`
   - This workflow will:
     - Build documentation using `generate_html_docs.sh`
     - Deploy to GitHub Pages automatically on pushes to `master`/`main`
   - The workflow triggers on:
     - Pushes to `master` or `main` branch (when files in `github_collection/` change)
     - Manual workflow dispatch

3. **After First Deployment:**
   - Your documentation will be available at:
     ```
     https://<username>.github.io/ansible-tricks/
     ```
   - Or if using a custom domain:
     ```
     https://your-custom-domain.com/
     ```

### Manual Publishing

If you want to publish manually without GitHub Actions:

1. **Generate the documentation:**
   ```bash
   cd github_collection
   ./generate_html_docs.sh
   ```

2. **The HTML files are now in:**
   ```
   github_collection/collections/ansible_collections/rstyczynski/github/docs/html/
   ```

3. **View locally:**
   ```bash
   cd github_collection/collections/ansible_collections/rstyczynski/github/docs/html
   python3 -m http.server 8000
   # Open http://localhost:8000 in your browser
   ```

### Updating galaxy.yml Documentation URL

After enabling GitHub Pages, update the `documentation` field in `galaxy.yml`:

```yaml
documentation: https://<username>.github.io/ansible-tricks/
```

## References

- [Ansible Collection Documentation Guide](https://docs.ansible.com/projects/ansible/latest/dev_guide/developing_collections_documenting.html)
- [GitHub Pages Documentation](https://docs.github.com/en/pages)
- [GitHub Actions for Pages](https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site#publishing-with-a-custom-github-actions-workflow)

