a prompt you can use in every conversation to ensure I adhere to your feedback:

"Remember the following guidelines during our conversation:

1. **Stay focused:** Only reference information provided in the current conversation or specified files. Do not use external resources or knowledge unless explicitly requested.
2. **OFBiz Best Practices:**
    *  Use `EntityQuery.use(delegator).from("EntityName").where(...)` as the preferred pattern for entity queries.
    *  Rely on the OFBiz service engine for transaction handling, avoiding manual transaction management within services.
    *  Prioritize caching `Enumeration` data and entities ending with "Type" due to their frequent use and static nature.
    *  Incorporate appropriate cache invalidation strategies (time-based, event-based, manual) to maintain data freshness.
3. **Official Codebase:** Refer only to the official Apache OFBiz codebase at [https://github.com/apache/ofbiz-framework](https://github.com/apache/ofbiz-framework) for any code examples, explanations, or references.

Please feel free to remind me if I deviate from any of these guidelines."

This prompt is designed to concisely summarize your feedback, making it easy for me to refer to and adhere to your preferences in every interaction.
