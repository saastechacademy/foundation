# Onboarding: Granting Access to D365 Dev Environments

This guide covers the steps required to onboard a new developer to our Dynamics 365 Finance and Supply Chain Management (FSCM) dev environment.

## Phase 1: Create the User Identity

Before granting specific access, the user must exist within our organization's directory.

1. Navigate to the Microsoft 365 Admin Center (admin.cloud.microsoft).
2. Go to **Users > Active users** and click **Add a user**.
3. Fill out their details to generate their organization email account (`@hotwax.co`) and assign the appropriate license.
4. Have the user log in once to ensure their identity is active.

## Phase 2: Grant Environment Access in Lifecycle Services (LCS)

This allows the user to see the project dashboard, view environment details, and retrieve the VM's local administrator credentials.

1. Log into Microsoft Dynamics Lifecycle Services (LCS).
2. Open the specific project: **D365-FSCM-Integration (hotwax.co)**.
3. Open the main navigation menu by clicking the Hamburger Menu (☰) at the top-left corner.
4. Select **Project users** (or go directly to the Project user management page).
5. Click the **+ (Add)** icon at the top left of the user table.
6. Configure the user details:
   - **Email**: the new user's organization email address.
   - **Project security role**: `Project team member`.
   - **Implementation role**: `Technical consultant` or `Developer`.
7. Click **Invite**.

## Phase 3: Grant Azure Infrastructure Access (VM Management)

This step ensures the user can see the VM in the Azure Portal to perform infrastructure tasks like starting, stopping, or restarting it.

1. Navigate to the **Add role assignment** page in Microsoft Azure for the dev environment's resource group.
2. In the **Role** tab, select **Virtual Machine Contributor**.
3. Click the **Members** tab (or **Next**).
4. Set **Assign access to** as `User, group, or service principal`.
5. Click **+ Select members**, search for the new team member's email, select them, and click **Select**.
6. Click **Review + assign** to finalize the permissions.

## Next Steps for the New User

Once Phases 1–3 are completed, the new user can:

1. Log into the Azure Portal to verify they see the VM `dev5212f40f43-1` and turn it on.
2. Go to the LCS environment details page to pull the Windows local account RDP credentials.
3. Establish a Remote Desktop connection to log in directly to the Windows Dev VM.
