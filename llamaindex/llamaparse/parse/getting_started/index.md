---
title: Getting Started | Developer Documentation
description: Quick start guide for Parse, covering API key generation and document parsing using Python, TypeScript, Go, Java, the CLI, the REST API, or the Web UI.
---

Using a coding agent?

Give your AI agent access to these docs: `claude mcp add llama-index-docs --transport http https://developers.llamaindex.ai/mcp` — or supercharge your agent with LlamaParse [MCP tools and Skills](/for-agents/index.md).

Get your first parse job running in under a minute—whether you prefer Python, TypeScript, Go, Java, the CLI, the REST API, or the Web UI.

## Before you begin

You’ll need a LlamaCloud API key. [**Get your API key →**](/llamaparse/general/api_key/index.md)

Set it as an environment variable so the SDKs pick it up automatically:

Terminal window

```
export LLAMA_CLOUD_API_KEY="llx-..."
```

## Your first parse job in 60 seconds

- [Python](#tab-panel-840)
- [TypeScript](#tab-panel-841)
- [Go](#tab-panel-842)
- [Java](#tab-panel-843)
- [CLI](#tab-panel-844)
- [REST API](#tab-panel-845)
- [Web UI](#tab-panel-846)

Install the SDK:

Terminal window

```
pip install llama-cloud>=2.8
```

Parse a document:

```
from llama_cloud import LlamaCloud


client = LlamaCloud()  # reads LLAMA_CLOUD_API_KEY from the environment


# Upload and parse a document
file = client.files.create(file="./attention_is_all_you_need.pdf", purpose="parse")
result = client.parsing.parse(
    file_id=file.id,
    tier="agentic",
    version="latest",
    expand=["markdown"],
)


# Print the markdown for the first page
print(result.markdown.pages[0].markdown)
```

That’s it. The SDK handles job polling for you—`client.parsing.parse()` blocks until the job finishes and returns the full result.

Prefer async? Swap `LlamaCloud` for `AsyncLlamaCloud` and `await` the calls:

```
from llama_cloud import AsyncLlamaCloud
import asyncio


async def main():
    client = AsyncLlamaCloud()
    file = await client.files.create(file="./attention_is_all_you_need.pdf", purpose="parse")
    result = await client.parsing.parse(file_id=file.id, tier="agentic", version="latest", expand=["markdown"])
    print(result.markdown.pages[0].markdown)


asyncio.run(main())
```

### Configure your parse job

The snippet above uses defaults. When you’re ready to tune the output, add `input_options`, `output_options`, or `processing_options`:

```
result = client.parsing.parse(
    file_id=file.id,
    tier="agentic",
    version="latest",
    output_options={
        "markdown": {"tables": {"output_tables_as_markdown": True}},
        "images_to_save": ["screenshot"],
    },
    processing_options={
        "ocr_parameters": {"languages": ["en"]},
    },
    expand=["text", "markdown", "items", "images_content_metadata"],
)
```

Each group has a dedicated reference page:

- [Input Options](/llamaparse/parse/guides/configuring-parse/#input-options/index.md) — page ranges, crop boxes, file-type-specific controls, and cache behavior
- [Output Options](/llamaparse/parse/guides/configuring-parse/#output-options/index.md) — markdown styling, spatial text, screenshots, tables-as-spreadsheet, and more
- [Processing Options](/llamaparse/parse/guides/configuring-parse/#processing-options/index.md) — OCR languages, ignore rules, chart parsing, cost optimizer
- [Retrieving Results](/llamaparse/parse/guides/retrieving-results/index.md) — every `expand` value and how to control what comes back

Install the SDK:

Terminal window

```
npm install @llamaindex/llama-cloud
```

Create a `parse.ts` file:

```
import LlamaCloud from '@llamaindex/llama-cloud';
import fs from 'fs';


const client = new LlamaCloud(); // reads LLAMA_CLOUD_API_KEY from the environment


// Upload and parse a document
const file = await client.files.create({
  file: fs.createReadStream('./attention_is_all_you_need.pdf'),
  purpose: 'parse',
});


const result = await client.parsing.parse({
  file_id: file.id,
  tier: 'agentic',
  version: 'latest',
  expand: ['markdown'],
});


// Print the markdown for the first page
console.log(result.markdown.pages[0].markdown);
```

Run it:

Terminal window

```
npx tsx parse.ts
```

The SDK handles job polling for you—`client.parsing.parse()` awaits until the job finishes and returns the full result.

### Configure your parse job

Pass `input_options`, `output_options`, or `processing_options` to tune the output:

```
const result = await client.parsing.parse({
  file_id: file.id,
  tier: 'agentic',
  version: 'latest',
  output_options: {
    markdown: { tables: { output_tables_as_markdown: true } },
    images_to_save: ['screenshot'],
  },
  processing_options: {
    ocr_parameters: { languages: ['en'] },
  },
  expand: ['text', 'markdown', 'items', 'images_content_metadata'],
});
```

See the dedicated reference pages for the full set of options:

- [Input Options](/llamaparse/parse/guides/configuring-parse/#input-options/index.md)
- [Output Options](/llamaparse/parse/guides/configuring-parse/#output-options/index.md)
- [Processing Options](/llamaparse/parse/guides/configuring-parse/#processing-options/index.md)
- [Retrieving Results](/llamaparse/parse/guides/retrieving-results/index.md) — every `expand` value and how to control what comes back

Install the SDK:

Terminal window

```
go get github.com/run-llama/llama-parse-go
```

Create a `main.go` file:

```
package main


import (
  "context"
  "fmt"
  "log"
  "os"
  "time"


  llamacloud "github.com/run-llama/llama-parse-go"
)


func main() {
  ctx := context.Background()
  client := llamacloud.NewClient() // reads LLAMA_CLOUD_API_KEY from the environment


  f, err := os.Open("./attention_is_all_you_need.pdf")
  if err != nil {
    log.Fatal(err)
  }
  defer f.Close()


  // Upload and parse a document
  file, err := client.Files.New(ctx, llamacloud.FileNewParams{
    File:    f,
    Purpose: "parse",
  })
  if err != nil {
    log.Fatal(err)
  }


  job, err := client.Parsing.New(ctx, llamacloud.ParsingNewParams{
    FileID:  llamacloud.String(file.ID),
    Tier:    llamacloud.ParsingNewParamsTierAgentic,
    Version: llamacloud.ParsingNewParamsVersionLatest,
  })
  if err != nil {
    log.Fatal(err)
  }


  // Poll until the job reaches a terminal status
  getParams := llamacloud.ParsingGetParams{Expand: []string{"markdown"}}
  result, err := client.Parsing.Get(ctx, job.ID, getParams)
  if err != nil {
    log.Fatal(err)
  }
  for result.Job.Status != "COMPLETED" && result.Job.Status != "FAILED" && result.Job.Status != "CANCELLED" {
    time.Sleep(2 * time.Second)
    result, err = client.Parsing.Get(ctx, job.ID, getParams)
    if err != nil {
      log.Fatal(err)
    }
  }


  if result.Job.Status != "COMPLETED" {
    log.Fatalf("parse ended as %s", result.Job.Status)
  }
  if len(result.Markdown.Pages) == 0 {
    log.Fatal("parse completed with no markdown pages")
  }


  // Print the markdown for the first page
  fmt.Println(result.Markdown.Pages[0].Markdown)
}
```

Run it:

Terminal window

```
go run main.go
```

### Configure your parse job

The snippet above uses defaults. When you’re ready to tune the output, add `InputOptions`, `OutputOptions`, or `ProcessingOptions`:

```
job, err := client.Parsing.New(ctx, llamacloud.ParsingNewParams{
  FileID:  llamacloud.String(file.ID),
  Tier:    llamacloud.ParsingNewParamsTierAgentic,
  Version: llamacloud.ParsingNewParamsVersionLatest,
  OutputOptions: llamacloud.ParsingNewParamsOutputOptions{
    Markdown: llamacloud.ParsingNewParamsOutputOptionsMarkdown{
      Tables: llamacloud.ParsingNewParamsOutputOptionsMarkdownTables{
        OutputTablesAsMarkdown: llamacloud.Bool(true),
      },
    },
    ImagesToSave: []string{"screenshot"},
  },
  ProcessingOptions: llamacloud.ParsingNewParamsProcessingOptions{
    OcrParameters: llamacloud.ParsingNewParamsProcessingOptionsOcrParameters{
      Languages: []llamacloud.ParsingLanguages{llamacloud.ParsingLanguagesEn},
    },
  },
})
```

Request the fields you want back when you fetch the result:

```
result, err := client.Parsing.Get(ctx, job.ID, llamacloud.ParsingGetParams{
  Expand: []string{"text", "markdown", "items", "images_content_metadata"},
})
```

Each group has a dedicated reference page:

- [Input Options](/llamaparse/parse/guides/configuring-parse/#input-options/index.md) — page ranges, crop boxes, file-type-specific controls, and cache behavior
- [Output Options](/llamaparse/parse/guides/configuring-parse/#output-options/index.md) — markdown styling, spatial text, screenshots, tables-as-spreadsheet, and more
- [Processing Options](/llamaparse/parse/guides/configuring-parse/#processing-options/index.md) — OCR languages, ignore rules, chart parsing, cost optimizer
- [Retrieving Results](/llamaparse/parse/guides/retrieving-results/index.md) — every `expand` value and how to control what comes back

Add the SDK to your build:

```
implementation("ai.llamaindex:llama-cloud:1.3.0")
```

Parse a document:

```
import ai.llamaindex.llamacloud.client.LlamaCloudClient;
import ai.llamaindex.llamacloud.client.okhttp.LlamaCloudOkHttpClient;
import ai.llamaindex.llamacloud.models.files.FileCreateParams;
import ai.llamaindex.llamacloud.models.files.FileCreateResponse;
import ai.llamaindex.llamacloud.models.parsing.ParsingCreateParams;
import ai.llamaindex.llamacloud.models.parsing.ParsingCreateResponse;
import ai.llamaindex.llamacloud.models.parsing.ParsingGetParams;
import ai.llamaindex.llamacloud.models.parsing.ParsingGetResponse;
import java.nio.file.Paths;


public class ParseExample {
    public static void main(String[] args) throws Exception {
        // reads LLAMA_CLOUD_API_KEY from the environment
        LlamaCloudClient client = LlamaCloudOkHttpClient.fromEnv();


        // Upload and parse a document
        FileCreateResponse file = client.files().create(FileCreateParams.builder()
                .file(Paths.get("./attention_is_all_you_need.pdf"))
                .purpose("parse")
                .build());


        ParsingCreateResponse job = client.parsing().create(ParsingCreateParams.builder()
                .fileId(file.id())
                .tier(ParsingCreateParams.Tier.AGENTIC)
                .version(ParsingCreateParams.Version.LATEST)
                .build());


        // Poll until the job reaches a terminal status
        ParsingGetParams getParams = ParsingGetParams.builder()
                .jobId(job.id())
                .addExpand("markdown")
                .build();


        ParsingGetResponse result = client.parsing().get(getParams);
        while (!result.job().status().equals(ParsingGetResponse.Job.Status.COMPLETED)
                && !result.job().status().equals(ParsingGetResponse.Job.Status.FAILED)
                && !result.job().status().equals(ParsingGetResponse.Job.Status.CANCELLED)) {
            Thread.sleep(2000);
            result = client.parsing().get(getParams);
        }


        if (!result.job().status().equals(ParsingGetResponse.Job.Status.COMPLETED)) {
            throw new RuntimeException("parse ended as " + result.job().status());
        }


        // Print the markdown for the first page
        System.out.println(result.markdown().get().pages().get(0).asMarkdownResult().markdown());
    }
}
```

### Configure your parse job

Pass `inputOptions`, `outputOptions`, or `processingOptions` to tune the output:

```
ParsingCreateResponse job = client.parsing().create(ParsingCreateParams.builder()
        .fileId(file.id())
        .tier(ParsingCreateParams.Tier.AGENTIC)
        .version(ParsingCreateParams.Version.LATEST)
        .outputOptions(ParsingCreateParams.OutputOptions.builder()
                .markdown(ParsingCreateParams.OutputOptions.Markdown.builder()
                        .tables(ParsingCreateParams.OutputOptions.Markdown.Tables.builder()
                                .outputTablesAsMarkdown(true)
                                .build())
                        .build())
                .addImagesToSave(ParsingCreateParams.OutputOptions.ImagesToSave.SCREENSHOT)
                .build())
        .processingOptions(ParsingCreateParams.ProcessingOptions.builder()
                .ocrParameters(ParsingCreateParams.ProcessingOptions.OcrParameters.builder()
                        .addLanguage(ParsingLanguages.EN)
                        .build())
                .build())
        .build());
```

Request the fields you want back when you fetch the result:

```
ParsingGetResponse result = client.parsing().get(ParsingGetParams.builder()
        .jobId(job.id())
        .addExpand("text")
        .addExpand("markdown")
        .addExpand("items")
        .addExpand("images_content_metadata")
        .build());
```

See the dedicated reference pages for the full set of options:

- [Input Options](/llamaparse/parse/guides/configuring-parse/#input-options/index.md)
- [Output Options](/llamaparse/parse/guides/configuring-parse/#output-options/index.md)
- [Processing Options](/llamaparse/parse/guides/configuring-parse/#processing-options/index.md)
- [Retrieving Results](/llamaparse/parse/guides/retrieving-results/index.md) — every `expand` value and how to control what comes back

Install the CLI:

Terminal window

```
go install github.com/run-llama/llama-parse-cli/cmd/llp@latest
```

`llp` reads `LLAMA_CLOUD_API_KEY` from the environment (or pass `--api-key`). Parse a document:

Terminal window

```
# Upload the document
FILE_ID=$(llp files create \
  --file ./attention_is_all_you_need.pdf \
  --purpose parse | jq -r '.id')


# Start a parse job
JOB_ID=$(llp parsing create \
  --file-id "$FILE_ID" \
  --tier agentic \
  --version latest | jq -r '.id')


# Poll until the job reaches a terminal status
while true; do
  STATUS=$(llp parsing get --job-id "$JOB_ID" | jq -r '.job.status')
  case "$STATUS" in COMPLETED|FAILED|CANCELLED) break ;; esac
  sleep 2
done


# Print the markdown for the first page
llp parsing get --job-id "$JOB_ID" --expand markdown \
  | jq -r '.markdown.pages[0].markdown'
```

### Configure your parse job

Every body field has a kebab-case flag. Nested objects take a YAML-ish blob, either on the top-level flag or on an inner flag:

Terminal window

```
llp parsing create \
  --file-id "$FILE_ID" \
  --tier agentic \
  --version latest \
  --output-options.markdown '{tables: {output_tables_as_markdown: true}}' \
  --output-options.images-to-save '[screenshot]' \
  --processing-options.ocr-parameters '{languages: [en]}'
```

Repeat `--expand` to request more fields on the result:

Terminal window

```
llp parsing get --job-id "$JOB_ID" \
  --expand text \
  --expand markdown \
  --expand items \
  --expand images_content_metadata
```

See the dedicated reference pages for the full set of options:

- [Input Options](/llamaparse/parse/guides/configuring-parse/#input-options/index.md)
- [Output Options](/llamaparse/parse/guides/configuring-parse/#output-options/index.md)
- [Processing Options](/llamaparse/parse/guides/configuring-parse/#processing-options/index.md)
- [Retrieving Results](/llamaparse/parse/guides/retrieving-results/index.md) — every `expand` value and how to control what comes back

If you’d prefer to skip the SDKs, the REST API lets you parse from any environment. Unlike the SDKs, the raw API is asynchronous: you upload a file, kick off a parse job, then poll for the result.

#### 1. Upload a file

Terminal window

```
curl -X POST \
  https://api.cloud.llamaindex.ai/api/v1/beta/files \
  -H 'Accept: application/json' \
  -H "Authorization: Bearer $LLAMA_CLOUD_API_KEY" \
  -F 'purpose=parse' \
  -F 'file=@/path/to/your/file.pdf;type=application/pdf'
```

Grab the `id` from the response:

```
{
  "id": "cafe1337-e0dd-4762-b5f5-769fef112558"
}
```

#### 2. Start a parse job

Terminal window

```
curl -X POST \
  'https://api.cloud.llamaindex.ai/api/v2/parse' \
  -H 'Accept: application/json' \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer $LLAMA_CLOUD_API_KEY" \
  --data '{
    "file_id": "<file_id>",
    "tier": "agentic",
    "version": "latest"
  }'
```

You’ll get a `job_id` back:

```
{
  "id": "c0defee1-76a0-42c3-bbed-094e4566b762",
  "status": "PENDING"
}
```

#### 3. Poll for the result

Call the result endpoint with your `job_id`. Keep polling until you see `COMPLETED`, then use `expand` to request the fields you want:

status moves under job on this endpoint

The job-creation response above has `status` at the top level. This endpoint nests the same field under `job` — read `job.status`, not `.status`. Reusing the create response’s `.status` path here will always read `undefined`.

Terminal window

```
curl -X GET \
  'https://api.cloud.llamaindex.ai/api/v2/parse/<job_id>?expand=markdown' \
  -H 'Accept: application/json' \
  -H "Authorization: Bearer $LLAMA_CLOUD_API_KEY"
```

See [Retrieving Results](/llamaparse/parse/guides/retrieving-results/index.md) for every available `expand` value.

If you’re non-technical or just want to sandbox Parse before writing any code, the Web UI is the fastest path.

![Parse Web UI upload view: llama.pdf loaded in the file list on the left, tier picker on the right with Agentic selected, and Advanced options showing input controls like page ranges and cache control.](/_astro/web_ui_upload.DOzzn4mL_TpQQa.png?dpl=dpl_65MMk4yr6WX444XkCiEKP7iHsp6k)

1. Go to [**cloud.llamaindex.ai/parse**](https://cloud.llamaindex.ai/parse)
2. Pick a **Tier** from **Recommended Settings**, or switch to **Advanced Settings** to customize
3. Upload your document (or pick one of the sample use cases to try Parse without uploading anything)
4. Click **Run Parse** and view the results directly in the browser

![Parse Web UI result view: the raw LLaMA paper PDF on the left and Parse's clean markdown output on the right, with headings, author block, and the abstract rendered in proper structure.](/_astro/web_ui_result.xa7mL4CM_119HLa.png?dpl=dpl_65MMk4yr6WX444XkCiEKP7iHsp6k)

### Choosing a tier

Parse offers four tiers:

- [**Agentic Plus**](/llamaparse/parse/guides/tiers/#agentic-plus/index.md) — state-of-the-art models for maximum accuracy on the hardest documents (complex tables, dense charts, multi-column layouts).
- [**Agentic**](/llamaparse/parse/guides/tiers/#agentic/index.md) — advanced parsing agents for visually rich documents; a strong default for most workloads.
- [**Cost Effective**](/llamaparse/parse/guides/tiers/#cost-effective/index.md) — balanced performance and cost for text-heavy documents with minimal visual structure.
- [**Fast**](/llamaparse/parse/guides/tiers/#fast/index.md) — the lowest-latency, lowest-cost tier for plain-text documents at high volume. Returns text and spatial text only — does not support markdown output.

## Alternative: use a coding agent

If you’re already using Claude Code, Cursor, or another coding agent, you can skip the SDK entirely. Install the Parse agent skill and your agent can parse documents on the fly:

Terminal window

```
npx skills add run-llama/llamaparse-agent-skills --skill llamaparse
```

Then just ask your agent things like:

- *“Parse this PDF and extract the text as markdown.”*
- *“Extract every table from each invoice in `./invoices` and save them as CSVs.”*
- *“Parse this financial report with cost optimizer enabled.”*

The agent writes the SDK calls for you. It picks the right tier, configures options, and saves output — without you needing to remember API details.

**Requirements:** Node 18+, `LLAMA_CLOUD_API_KEY` in the environment, and a coding agent that supports [Vercel-style skills](https://skills.sh).

A second skill, `liteparse`, runs locally with no API key — best for plain text and simple layouts. For both skills, the agent plugins that bundle them, and Codex setup, see [Skills and Plugins](/llamaparse/for-agents/skills/index.md).

Troubleshooting

If the agent doesn’t see the skill: (1) run the install in the project root, (2) restart the agent session, (3) confirm `LLAMA_CLOUD_API_KEY` is set in the agent’s process environment.

## Next steps

- **Choose the right tier** → [Tiers](/llamaparse/parse/guides/tiers/index.md) explains when to use Agentic Plus vs. Agentic vs. Cost Effective vs. Fast.
- **Learn to configure options** → [Configuring Parse](/llamaparse/parse/guides/configuring-parse/index.md) covers every knob — input, output, and processing options.
- **Save money on long documents** → [Cost Optimizer](/llamaparse/parse/guides/configuring-parse/#cost-optimizer/index.md) routes each page to the right tier automatically.
- **See real examples** → [Parse Examples](/llamaparse/parse/examples/index.md) — runnable tutorials for common use cases.

## Resources

- [Pricing & credits](/llamaparse/general/pricing/index.md)
- Need structured data instead of markdown? Check out [LlamaExtract](/llamaparse/extract/index.md).
