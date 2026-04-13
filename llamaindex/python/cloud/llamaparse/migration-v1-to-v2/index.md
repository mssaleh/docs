---
title: Migration Guide: Parse Upload Endpoint v1 to v2 | LlamaIndex OSS Documentation
description: Learn how to migrate from LlamaParse v1 to v2 endpoints, including the new specialized endpoint structure, configuration changes, parameter mapping, and code examples for file IDs, multipart uploads, and URL parsing
---

This guide will help you migrate from the v1 Parse upload endpoint to the new v2 endpoint, which introduces a structured configuration approach and improved organization of parsing options.

## Overview of Changes

The v2 endpoint replaces **individual form parameters** with a **single JSON configuration string**, providing:

- **Better organization**: Related options are grouped into logical sections
- **Type safety**: Structured validation with clear schemas
- **Extensibility**: Easier to add new features without endpoint bloat
- **Validation**: Better error messages and configuration validation

## Key Differences

### v1 Endpoint

```
POST /api/v1/parsing/upload
Content-Type: multipart/form-data


- 70+ individual form parameters
- Flat parameter structure
- All parameters available regardless of parse mode
```

### v2 Endpoints

```
POST /api/v2/parse            (file by ID or URL)
POST /api/v2/parse/upload     (multipart file upload)


- Two endpoints: JSON for file ID/URL, multipart for file uploads
- Single 'configuration' JSON parameter per endpoint
- Hierarchical, structured configuration
- Always-enabled optimizations
- Strict validation with clear error messages
```

## Migration Steps

### 1. Update the Endpoint URL

**Before (v1):**

```
POST https://api.cloud.llamaindex.ai/api/v1/parsing/upload
```

**After (v2):** Choose the appropriate endpoint based on your input method:

Terminal window

```
# For parsing existing files by ID or from URLs (recommended)
POST https://api.cloud.llamaindex.ai/api/v2/parse


# For multipart file uploads
POST https://api.cloud.llamaindex.ai/api/v2/parse/upload
```

### 2. Choose the Appropriate Endpoint and Configuration

v2 provides two endpoints for different input methods. Choose the one that matches how you’re providing the document:

#### JSON Parsing (Recommended)

For parsing an already uploaded file by ID or a document from a URL, use `/parse` with either `file_id` or `source_url` in the request body. Exactly one must be provided.

#### Multipart File Upload

For traditional file uploads, use `/parse/upload` with multipart form data and a `configuration` parameter.

### 3. Replace Form Parameters with Configuration JSON

The configuration approach depends on your chosen endpoint:

- **`/parse`**: Uses JSON request body with either `file_id` or `source_url` (plus optional `http_proxy`) and configuration fields
- **`/parse/upload`**: Uses multipart form data with `file` and `configuration` parameters

### 4. Migration Checklist

Before migrating, review this checklist:

- [ ] **Choose the right endpoint**: Select `/parse` for file ID or URL, `/parse/upload` for multipart uploads
- [ ] **Update request format**: Change from form parameters to endpoint-specific configuration
- [ ] **Replace parse modes with tiers**: Use `tier` instead of `parse_mode` (`fast`, `cost_effective`, `agentic`, `agentic_plus`)
- [ ] **Remove model selection**: Models are now automatically selected based on tier
- [ ] **Move custom prompts**: Custom prompts are now under `agentic_options.custom_prompt` (only for agentic tiers)
- [ ] **Remove external provider configs**: Azure OpenAI and external API keys are no longer supported
- [ ] **Check for always-enabled parameters**: `high_res_ocr` is always enabled in v2
- [ ] **Check for table heuristic parameters**: `adaptive_long_table` and `outlined_table_extraction` are enabled by default in v2. They can be disabled with `processing_options.disable_heuristics`
- [ ] **Move specialized chart parsing parameters**: `specialized_chart_parsing_agentic`, `specialized_chart_parsing_plus`, `specialized_chart_parsing_efficient` are now under `processing_options.specialized_chart_parsing`
- [ ] **Update page indexing**: Change `target_pages` from 0-based to 1-based indexing
- [ ] **Move language parameter**: Move `language` to `processing_options.ocr_parameters`
- [ ] **Update cache parameters**: Replace `invalidate_cache` + `do_not_cache` with single `disable_cache`
- [ ] **Convert webhooks**: Replace `webhook_url` with `webhook_configurations` array (different payload format — see table below)
- [ ] **Remove header/footer customization**: Header/footer handling is now automatic
- [ ] **Use correct input field**: Use either `file_id` or `source_url` in `/parse` endpoint (exactly one required)
- [ ] **Test thoroughly**: The alpha API may have additional breaking changes

## Configuration Structure

The v2 configuration structure varies by endpoint:

### JSON Parsing (`/parse`)

Use either `file_id` or `source_url` (exactly one is required):

```
{
  "file_id": "existing-file-id",
  // OR use source_url instead:
  "source_url": "https://example.com/document.pdf",
  "http_proxy": "https://proxy.example.com", // optional, only with source_url


  "tier": "fast|cost_effective|agentic|agentic_plus",
  "version": "latest|2026-01-08|2025-12-31|2025-12-18|2025-12-11",
  "processing_options": {
    "ignore": {...},
    "ocr_parameters": {...},
    "aggressive_table_extraction": false,
    "auto_mode_configuration": [...]
  },
  "agentic_options": {
    "custom_prompt": "..." // Only for cost_effective, agentic, agentic_plus tiers
  },
  "webhook_configurations": [...],
  "input_options": {...},
  "crop_box": {...},
  "page_ranges": {...},
  "disable_cache": false,
  "output_options": {...},
  "processing_control": {...}
}
```

### Multipart Upload (`/parse/upload`)

Uses multipart/form-data with a `file` field and a `configuration` JSON field:

```
{
  "tier": "fast|cost_effective|agentic|agentic_plus",
  "version": "latest|2026-01-08|2025-12-31|2025-12-18|2025-12-11",
  "processing_options": {...},
  "agentic_options": {
    "custom_prompt": "..." // Only for cost_effective, agentic, agentic_plus tiers
  },
  "webhook_configurations": [...],
  "input_options": {...},
  "crop_box": {...},
  "page_ranges": {...},
  "disable_cache": false,
  "output_options": {...},
  "processing_control": {...}
}
```

## Parameter Mapping Reference

### Basic Options

| v1 Parameter                          | v2 Location                                   | Notes                                                                                   |
| ------------------------------------- | --------------------------------------------- | --------------------------------------------------------------------------------------- |
| `input_url`                           | `source_url`                                  | Renamed                                                                                 |
| `http_proxy`                          | `http_proxy`                                  | Same functionality                                                                      |
| `max_pages`                           | `page_ranges.max_pages`                       | Same functionality                                                                      |
| `target_pages`                        | `page_ranges.target_pages`                    | **Breaking change**: Now uses 1-based indexing (user inputs “1,2,3” instead of “0,1,2”) |
| `invalidate_cache` and `do_not_cache` | `disable_cache`                               | **Breaking change**: Single boolean combines both v1 parameters                         |
| `language`                            | `processing_options.ocr_parameters.languages` | Same functionality                                                                      |

> **Important**: In v1, `target_pages` used 0-based indexing (e.g., “0,1,2” for pages 1, 2, 3). In v2, it uses 1-based indexing (e.g., “1,2,3” for the same pages) to be homogenous with the rest of the platform.

### Always Enabled in v2 (Breaking Changes)

The following parameters are **always enabled** in v2 across all tiers and cannot be disabled. We’re doing this to simplify calling LlamaParse and because these options give better results:

| v1 Parameter           | v2 Behavior                                                             | Breaking Change                        |
| ---------------------- | ----------------------------------------------------------------------- | -------------------------------------- |
| `high_res_ocr`         | Always `true`                                                           | **Breaking**: Cannot be disabled in v2 |
| `precise_bounding_box` | Always `true` for `cost_effective`, `agentic`, and `agentic_plus` tiers | **Breaking**: Cannot be disabled in v2 |

### Configurable in v2 (Different v1 Defaults)

The following parameters are now configurable but have different defaults:

| v1 Parameter            | v2 Equivalent                                           | v2 Default | Notes                                                  |
| ----------------------- | ------------------------------------------------------- | ---------- | ------------------------------------------------------ |
| `guess_xlsx_sheet_name` | `output_options.tables_as_spreadsheet.guess_sheet_name` | `true`     | Always true when `tables_as_spreadsheet.enable` is set |

### Tier-Based Parameter Migration

| v1 Parameter             | v2 Location                                   | Notes                                                                                  |
| ------------------------ | --------------------------------------------- | -------------------------------------------------------------------------------------- |
| `parse_mode`             | `tier`                                        | **Breaking**: Now uses tier-based system                                               |
| `model`                  | Automatic selection                           | **Breaking**: Model is selected automatically based on tier                            |
| `parsing_instruction`    | `agentic_options.custom_prompt`               | **Breaking**: Only available for `cost_effective`, `agentic`, and `agentic_plus` tiers |
| `formatting_instruction` | **Removed**                                   | **Breaking**: Use `agentic_options.custom_prompt` instead                              |
| `system_prompt`          | `agentic_options.custom_prompt`               | **Breaking**: Consolidated into single custom prompt                                   |
| `system_prompt_append`   | `agentic_options.custom_prompt`               | **Breaking**: Consolidated into single custom prompt                                   |
| `user_prompt`            | **Removed**                                   | **Breaking**: Use `agentic_options.custom_prompt` instead                              |
| `language`               | `processing_options.ocr_parameters.languages` | Same functionality                                                                     |

### Removed/Deprecated Parameters

The following v1 parameters are **not supported** in v2:

| v1 Parameter                                   | v2 Status                    | Migration Path                                                                     |
| ---------------------------------------------- | ---------------------------- | ---------------------------------------------------------------------------------- |
| `use_vendor_multimodal_model`                  | **Removed** (was deprecated) | Use appropriate tier instead                                                       |
| `gpt4o_mode`                                   | **Removed**                  | Use `tier: "cost_effective"` for GPT-4o-mini or `tier: "agentic_plus"` for premium |
| `gpt4o_api_key`                                | **Removed**                  | External provider support removed for simplification                               |
| `premium_mode`                                 | **Removed**                  | Use `tier: "agentic_plus"` for highest quality                                     |
| `fast_mode`                                    | **Removed**                  | Use `tier: "fast"` for fastest processing                                          |
| `continuous_mode`                              | **Removed**                  | No direct equivalent                                                               |
| `vendor_multimodal_api_key`                    | **Removed**                  | **Breaking**: External providers removed for simplification                        |
| `azure_openai_*`                               | **Removed**                  | **Breaking**: External providers removed for simplification                        |
| `bounding_box`                                 | **Renamed**                  | Use `crop_box` object instead                                                      |
| `disable_image_extraction`                     | **Removed**                  | **Breaking**: Image extraction is now always optimized automatically               |
| `hide_headers`                                 | **Removed**                  | **Breaking**: Header handling is now automatic                                     |
| `hide_footers`                                 | **Removed**                  | **Breaking**: Footer handling is now automatic                                     |
| `page_header_prefix`                           | **Removed**                  | **Breaking**: Header formatting removed for simplification                         |
| `page_footer_prefix`                           | **Removed**                  | **Breaking**: Footer formatting removed for simplification                         |
| `page_prefix`                                  | **Removed**                  | **Breaking**: Page prefix formatting removed for simplification                    |
| `page_separator`                               | **Removed**                  | **Breaking**: Custom page separators removed for simplification                    |
| `keep_page_separator_when_merging_tables`      | **Removed**                  | **Breaking**: Table merging behavior is now optimized automatically                |
| `input_s3_path` and `input_s3_region`          | **Removed**                  | Not supported in v2                                                                |
| `output_s3_path_prefix` and `output_s3_region` | **Removed**                  | Not supported in v2                                                                |
| `output_pdf_of_document`                       | **Removed**                  | PDF of document is always generated in v2                                          |

### Webhook Configuration Breaking Changes

| v1 Parameter                      | v2 Location                      | Notes                                                                                                                                                                      |
| --------------------------------- | -------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `webhook_url`                     | **No direct equivalent**         | **Breaking**: v1 POSTed raw parse results (`{txt, md, json, images}`). v2 uses event-style notifications instead — see [Webhooks guide](/cloud/general/webhooks/index.md). |
| `webhook_configurations` (string) | `webhook_configurations` (array) | **Breaking**: Changed from JSON string to structured array with event notifications (`{event_id, event_type, data}`).                                                      |

### Not Yet Implemented in v2

The following options exist in the v2 schema but are not yet implemented:

- `input_options.pdf.password` (placeholder for future implementation)

### New v2 Features (No v1 Equivalent)

The following features are new in v2 and have no direct v1 equivalent:

| v2 Parameter                                                    | Description                                                                                                                                                |
| --------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `output_options.images_to_save`                                 | Array specifying which image categories to save: `"screenshot"` (full page), `"embedded"` (images in document), `"layout"` (cropped from layout detection) |
| `processing_options.auto_mode_configuration`                    | Advanced feature for conditional parsing with triggers and per-condition configurations                                                                    |
| `input_options.spreadsheet.force_formula_computation_in_sheets` | Force re-computation of spreadsheet cells containing formulas                                                                                              |

### Crop Box Options

| v1 Parameter  | v2 Location       |
| ------------- | ----------------- |
| `bbox_top`    | `crop_box.top`    |
| `bbox_bottom` | `crop_box.bottom` |
| `bbox_left`   | `crop_box.left`   |
| `bbox_right`  | `crop_box.right`  |

### Input Format Options

| v1 Parameter                            | v2 Location                                                     |
| --------------------------------------- | --------------------------------------------------------------- |
| `html_make_all_elements_visible`        | `input_options.html.make_all_elements_visible`                  |
| `html_remove_fixed_elements`            | `input_options.html.remove_fixed_elements`                      |
| `html_remove_navigation_elements`       | `input_options.html.remove_navigation_elements`                 |
| `spreadsheet_extract_sub_tables`        | `input_options.spreadsheet.detect_sub_tables_in_sheets`         |
| `spreadsheet_force_formula_computation` | `input_options.spreadsheet.force_formula_computation_in_sheets` |
| `presentation_out_of_bounds_content`    | `input_options.presentation.out_of_bounds_content`              |
| `presentation_skip_embedded_data`       | `input_options.presentation.skip_embedded_data`                 |

### Processing Options

| v1 Parameter                                        | v2 Location                                                 |
| --------------------------------------------------- | ----------------------------------------------------------- |
| `aggressive_table_extraction`                       | `processing_options.aggressive_table_extraction`            |
| `outlined_table_extraction` + `adaptive_long_table` | `processing_options.disable_heuristics` (inverted)          |
| `specialized_chart_parsing_efficient`               | `processing_options.specialized_chart_parsing: "efficient"` |

### Ignore Options

| v1 Parameter         | v2 Location                                      |
| -------------------- | ------------------------------------------------ |
| `skip_diagonal_text` | `processing_options.ignore.ignore_diagonal_text` |
| `disable_ocr`        | `processing_options.ignore.ignore_text_in_image` |
| `remove_hidden_text` | `processing_options.ignore.ignore_hidden_text`   |

### Output Options

| v1 Parameter                                | v2 Location                                                           |
| ------------------------------------------- | --------------------------------------------------------------------- |
| `annotate_links`                            | `output_options.markdown.annotate_links`                              |
| `page_suffix`                               | **Removed**                                                           |
| `hide_headers`                              | **Removed**                                                           |
| `hide_footers`                              | **Removed**                                                           |
| `compact_markdown_table`                    | `output_options.markdown.tables.compact_markdown_tables`              |
| `output_tables_as_HTML`                     | `output_options.markdown.tables.output_tables_as_markdown` (inverted) |
| `markdown_table_multiline_header_separator` | `output_options.markdown.tables.markdown_table_multiline_separator`   |
| `merge_tables_across_pages_in_markdown`     | `output_options.markdown.tables.merge_continued_tables`               |
| `guess_xlsx_sheet_name`                     | `output_options.tables_as_spreadsheet.guess_sheet_name`               |
| `extract_layout`                            | **Removed**                                                           |
| `save_images`                               | `output_options.images_to_save`                                       |
| `take_screenshot`                           | `output_options.images_to_save: ["screenshot"]`                       |
| `extract_printed_page_number`               | `output_options.extract_printed_page_number`                          |

### Spatial Text Options

| v1 Parameter                             | v2 Location                                                          |
| ---------------------------------------- | -------------------------------------------------------------------- |
| `preserve_layout_alignment_across_pages` | `output_options.spatial_text.preserve_layout_alignment_across_pages` |
| `preserve_very_small_text`               | `output_options.spatial_text.preserve_very_small_text`               |
| `do_not_unroll_columns`                  | `output_options.spatial_text.do_not_unroll_columns`                  |

### Processing Control

| v1 Parameter                                 | v2 Location                                                                       |
| -------------------------------------------- | --------------------------------------------------------------------------------- |
| `job_timeout_in_seconds`                     | `processing_control.timeouts.base_in_seconds`                                     |
| `job_timeout_extra_time_per_page_in_seconds` | `processing_control.timeouts.extra_time_per_page_in_seconds`                      |
| `page_error_tolerance`                       | `processing_control.job_failure_conditions.allowed_page_failure_ratio`            |
| `strict_mode_image_extraction`               | `processing_control.job_failure_conditions.fail_on_image_extraction_error`        |
| `strict_mode_image_ocr`                      | `processing_control.job_failure_conditions.fail_on_image_ocr_error`               |
| `strict_mode_reconstruction`                 | `processing_control.job_failure_conditions.fail_on_markdown_reconstruction_error` |
| `strict_mode_buggy_font`                     | `processing_control.job_failure_conditions.fail_on_buggy_font`                    |

## Error Handling

API v2 provides more detailed error messages:

### v1 Errors:

```
400: Invalid parameter combination
```

### v2 Errors:

```
{
  "detail": [
    {
      "type": "value_error",
      "loc": ["tier"],
      "msg": "Unsupported tier: invalid_tier. Must be one of: fast, cost_effective, agentic, agentic_plus",
      "input": {...}
    }
  ]
}
```

## Image Output Control

v2 introduces a new `images_to_save` parameter that provides fine-grained control over which images are saved during parsing. This replaces the v1 `save_images` and `take_screenshot` boolean flags.

### Image Categories

| Category     | Description                                           |
| ------------ | ----------------------------------------------------- |
| `screenshot` | Full page screenshots (replaces v1 `take_screenshot`) |
| `embedded`   | Images embedded within the document                   |
| `layout`     | Cropped images from layout detection                  |

### Examples

**Save only screenshots:**

```
{
  "output_options": {
    "images_to_save": ["screenshot"]
  }
}
```

**Save screenshots, embedded images and layout crops:**

```
{
  "output_options": {
    "images_to_save": ["screenshots", "embedded", "layout"]
  }
}
```

> **Note**: If `images_to_save` is not specified, images are not saved by default in v2 (unlike in v1 where `save_images` defaulted to true).

## Retrieving Results with Presigned URLs

v2 introduces a new way to retrieve binary outputs (XLSX, PDF, images) using presigned S3 URLs. Instead of streaming the file content directly through the API, v2 returns metadata with a temporary presigned URL for direct download.

### Retrieving XLSX Files

Use the `xlsx_content_metadata` expand parameter:

Terminal window

```
curl -X 'GET' \
  'https://api.cloud.llamaindex.ai/api/v2/parse/{job_id}?expand=xlsx_content_metadata' \
  -H 'Authorization: Bearer $LLAMA_CLOUD_API_KEY'
```

Response:

```
{
  "job": { ... },
  "result_content_metadata": {
    "xlsx": {
      "size_bytes": 15234,
      "exists": true,
      "presigned_url": "https://s3.amazonaws.com/..."
    }
  }
}
```

### Retrieving Exported PDFs

Use the `output_pdf_content_metadata` expand parameter:

Terminal window

```
curl -X 'GET' \
  'https://api.cloud.llamaindex.ai/api/v2/parse/{job_id}?expand=output_pdf_content_metadata' \
  -H 'Authorization: Bearer $LLAMA_CLOUD_API_KEY'
```

Response:

```
{
  "job": { ... },
  "result_content_metadata": {
    "outputPDF": {
      "size_bytes": 102400,
      "exists": true,
      "presigned_url": "https://s3.amazonaws.com/..."
    }
  }
}
```

### Retrieving Images

Use the `images_content_metadata` expand parameter:

Terminal window

```
curl -X 'GET' \
  'https://api.cloud.llamaindex.ai/api/v2/parse/{job_id}?expand=images_content_metadata' \
  -H 'Authorization: Bearer $LLAMA_CLOUD_API_KEY'
```

Response:

```
{
  "job": { ... },
  "images_content_metadata": {
    "total_count": 3,
    "images": [
      {
        "index": 0,
        "filename": "image_0.png",
        "content_type": "image/png",
        "size_bytes": 12345,
        "presigned_url": "https://s3.amazonaws.com/..."
      },
      {
        "index": 1,
        "filename": "image_1.jpg",
        "content_type": "image/jpeg",
        "size_bytes": 23456,
        "presigned_url": "https://s3.amazonaws.com/..."
      }
    ]
  }
}
```

Each image entry contains:

- `index`: Index of the image in extraction order
- `filename`: Image filename (e.g., “image\_0.png”)
- `content_type`: MIME type of the image
- `size_bytes`: Size of the image file in bytes
- `presigned_url`: Temporary URL to download the image

> **Note**: Presigned URLs are temporary and expire after a limited time. Download the files promptly after receiving the URLs.

> The v1 endpoint will remain available for the foreseeable future, so you can migrate at your own pace. However, new features and improvements will be focused on the v2 endpoint structure.
